# Axiell Adapter → FOLIO Upsert Strategy

## Summary

Every time the Axiell Collections (AxC) adapter runs (trigger → loader → transformer), the pipeline should also upsert item-level data into FOLIO. Source MARCXML from Axiell is transformed via XSL into FOLIO-compatible payloads and written to FOLIO Inventory APIs.

---

## Current Axiell Adapter Architecture (Analysis)

### Pipeline Stages

```
EventBridge Scheduler
    │
    ▼
┌──────────┐    ┌──────────┐    ┌────────────────────┐    ┌─────────────────┐
│  Trigger │───▶│  Loader  │───▶│  Transformer (ES)  │───▶│  Elasticsearch  │
└──────────┘    └──────────┘    └────────────────────┘    └─────────────────┘
                     │
                     ▼
              Iceberg Adapter Table
```

### Stage Responsibilities

| Stage | File | Role |
|-------|------|------|
| Trigger | `src/adapters/steps/oai_pmh/trigger.py` | Compute next harvest window from WindowStore history |
| Loader | `src/adapters/steps/oai_pmh/loader.py` | Harvest OAI-PMH records in window, write raw MARCXML to Iceberg, emit `changeset_ids` |
| Transformer | `src/adapters/steps/transformer.py` + `src/adapters/transformers/axiell_transformer.py` | Read changesets from Iceberg, parse MARCXML with pymarc, produce SourceWork, index to ES |
| Reconciler | `src/adapters/transformers/axiell_reconciler.py` | Track GUID→ID mapping changes, emit DeletedSourceWork for superseded identifiers |

### Key Characteristics

- **Metadata prefix**: `oai_marcxml`
- **OAI set**: `collect`
- **Auth**: Custom `Token` header (not standard `Authorization`)
- **Identity**: `axiell-guid` from MARC 001
- **Visibility**: `InvisibleSourceWork` (MimsyWorksAreNotVisible)
- **Window cadence**: 15 min windows, 7 day lookback, 360 min max lag
- **Storage**: Single Iceberg table schema (`namespace`, `id`, `content`, `changeset`, `last_modified`, `deleted`)

### What the Transformer Currently Does

`AxiellTransformer` extends `MarcXmlTransformer` and extracts:
- Title (MARC 245)
- Alternative titles
- Other identifiers
- Notes
- Version from source modified timestamp

It does **not** produce item-level data or write to any external system beyond ES.

---

## Proposed Change: FOLIO Item Upsert on Every Adapter Run

### Target Architecture

```
EventBridge Scheduler
    │
    ▼
┌──────────┐    ┌──────────┐         ┌────────────────────┐    ┌─────────────────┐
│  Trigger │───▶│  Loader  │────┬───▶│  Transformer (ES)  │───▶│  Elasticsearch  │
└──────────┘    └──────────┘    │    └────────────────────┘    └─────────────────┘
                     │          │
                     ▼          │    ┌──────────────────────────────────────────────┐
              Iceberg Table     └───▶│  FOLIO Item Upserter (new step)              │
                                     │  1. Read changesets from Iceberg              │
                                     │  2. Apply XSL → FOLIO item-level payload     │
                                     │  3. Upsert via FOLIO Inventory API           │
                                     └──────────────────────────────────────────────┘
                                                     │
                                                     ▼
                                              ┌──────────────┐
                                              │  FOLIO       │
                                              │  Inventory   │
                                              └──────────────┘
```

### Fan-out Mechanism

After loader emits `changeset_ids`, EventBridge routes the event to **two** downstream targets:
1. Existing Axiell ES transformer (unchanged).
2. New FOLIO item upserter step.

Both consume the same `changeset_ids` independently and can retry/fail independently.

---

## XSL Transformation Design

### Why XSL

- Axiell raw MARCXML is not directly compatible with FOLIO Inventory API schemas.
- XSL provides declarative, versionable, testable mapping from source XML to target shape.
- Mirrors the proven CALM→Sierra pattern (CalmInnopac.xsl).
- Separates mapping logic from Python business code — cataloguers and metadata staff can review/adjust XSL without touching application code.

### Transformation Pipeline

```
Raw MARCXML (from Iceberg)
    │
    ▼
┌────────────────────────────────────────┐
│  XSL Engine (lxml.etree.XSLT)         │
│  Stylesheet: axiell_to_folio_item.xsl  │
│  Input: raw MARCXML record             │
│  Output: FOLIO item-level JSON/XML     │
└────────────────────────────────────────┘
    │
    ▼
┌────────────────────────────────────────┐
│  Schema Validation                     │
│  Validate required fields present      │
│  Check identifiers well-formed         │
└────────────────────────────────────────┘
    │
    ▼
┌────────────────────────────────────────┐
│  FOLIO API Payload Builder             │
│  Map validated output to FOLIO         │
│  Inventory API request shape           │
└────────────────────────────────────────┘
```

### XSL File Location

```
catalogue_graph/
  src/
    adapters/
      transformers/
        xsl/
          axiell_to_folio_item.xsl      ← main stylesheet
          axiell_to_folio_item_v2.xsl   ← versioned iteration
```

### XSL Versioning

- Stylesheet version is passed in the step event (`xsl_version` field).
- Manifest records which XSL version produced each output.
- Allows rollback and A/B comparison during mapping refinement.

### Field Mapping (Initial Target)

| MARC Source (Axiell) | XSL Output | FOLIO Target |
|---------------------|------------|--------------|
| 001 (GUID) | `external_id` | Item `hrid` or external identifier |
| 245$a | `title` | Instance title (for linkage) |
| 852$b | `location_code` | Item effective location |
| 852$c | `shelving_location` | Item shelving location |
| 852$h | `call_number` | Item call number |
| 949$a | `barcode` | Item barcode |
| 949$c | `item_type` | Material type mapping |
| 949$l | `loan_type` | Loan type |
| 876$p | `copy_number` | Copy number |
| 876$t | `volume` | Volume designation |
| 856$u | `electronic_access_uri` | Electronic access |

> Field mapping is to for representation— confirm with metadata team before implementation.


### FOLIO API Client

**Location**: `src/adapters/extractors/oai_pmh/axiell/folio_write_client.py`

Responsibilities:
- Authenticate to FOLIO (OKAPI token or similar).
- Search items by external identifier.
- Create/update item records.
- Handle rate limiting and retries.


### Upsert Key Strategy

Priority order for matching:
1. External source identifier (`axiell-guid` from MARC 001).
2. Barcode from transformed record (949$a).
3. Composite fallback: `axiell:{record_id}`.

Behavior:
- **Found**: update mutable fields, preserve FOLIO-internal metadata.
- **Not found**: create new item, link to holding/instance via location.
- **Missing required fields**: skip with structured error logged.


### Replay Safety

- Upserts are idempotent by external identifier.
- Same changeset processed twice produces same outcome.
- Manifest deduplication: check if changeset already processed successfully before running.

---

## Observability

### Structured Logs (structlog)

```python
log.info("folio_item_upsert",
    job_id=job_id,
    changeset_id=changeset_id,
    record_id=record.id,
    action="created" | "updated" | "skipped" | "failed",
    xsl_version=xsl_version,
    duration_ms=elapsed)
```
---

## Comparison: Current vs Proposed

| Aspect | Current | Proposed |
|--------|---------|----------|
| Downstream targets | Elasticsearch only | Elasticsearch + FOLIO |
| Transform method | pymarc field extraction | pymarc (ES) + XSL (FOLIO) |
| FOLIO interaction | Read-only (OAI harvest) | Read + Write (Item upsert) |
| Failure coupling | Single path | Independent paths (fan-out) |
| Replay | Changeset-based | Same — both paths replayable |
| Deletion handling | Reconciler → ES | Reconciler → ES + FOLIO suppress |

---

## Change Detection: How to Know What Data Has Changed

### Mechanism Already Available

The Axiell adapter's existing window-based OAI-PMH harvesting already solves change detection:

1. **OAI-PMH datestamp windows** — Loader harvests records modified within a time window. Only records with `last_modified` within `[window_start, window_end)` are returned.
2. **Changeset IDs** — Each harvest window produces a unique `changeset_id`. Records written to Iceberg in that window are tagged with it.
3. **Iceberg `last_modified` column** — Timestamp from the OAI datestamp header; reflects when the source record was last touched.
4. **Iceberg `deleted` flag** — Set to `true` when OAI returns a tombstone for a record.

### Change Detection for FOLIO Upsert

The FOLIO upsert step receives `changeset_ids` and reads only those rows:

```python
changed_records = adapter_store.read_changed(changeset_ids)
```

Every record in the changeset is either:
- **New** (first time this `id` appears in Iceberg) → create in FOLIO. (not sure if we would do this ?)
- **Updated** (existing `id`, newer `last_modified`) → update in FOLIO.
- **Deleted** (`deleted=true`) → suppress/remove in FOLIO.


### Summary of Change Signals

| Signal | Source | Meaning |
|--------|--------|---------|
| Record in changeset | OAI-PMH datestamp window | Record was created or modified in source |
| `deleted=true` | OAI tombstone | Record was removed from source |
| Payload hash mismatch | XSL output comparison | FOLIO-relevant fields actually changed |
| Reconciler GUID remap | Axiell reconciler step | Old identity superseded, emit delete for old |

---

## FOLIO API Comparison for Record Update

### Available APIs (mod-inventory v14.0)

| API Endpoint | Method | Use Case | Identifier Required | Batch? | Notes |
|-------------|--------|----------|--------------------:|--------|-------|
| `/inventory/items` | `POST` | Create new item | None (FOLIO generates UUID) | No | Returns created item with `id` |
| `/inventory/items/{itemId}` | `PUT` | Full replace of item | FOLIO UUID (`id`) | No | Requires full object; 409 on version conflict |
| `/inventory/items/{itemId}` | `PATCH` | Partial update of item | FOLIO UUID (`id`) + `_version` | No | Only send changed fields |
| `/inventory/items` | `GET` | Search/find items | CQL query (e.g. `barcode==X`) | No | Used to resolve external ID → FOLIO UUID |
| `/inventory/instances` | `POST` | Create instance | None | No | Required fields: `source`, `title`, `instanceTypeId` |
| `/inventory/instances/{id}` | `PUT` | Full update instance | FOLIO UUID | No | Full object replace |
| `/inventory/instances/{id}` | `PATCH` | Partial update instance | FOLIO UUID + `_version` | No | Optimistic locking |
| `/inventory/holdings/{id}` | `PUT` | Update holdings | FOLIO UUID | No | Required: `instanceId`, `permanentLocationId` |
| `/item-storage/items` | `POST` (batch-sync) | Batch upsert items | FOLIO UUIDs | **Yes** | See batch section below |
| `/instance-storage/instances` | `POST` (batch-sync) | Batch upsert instances | FOLIO UUIDs | **Yes** | See batch section below |
| `/holdings-storage/holdings` | `POST` (batch-sync) | Batch upsert holdings | FOLIO UUIDs | **Yes** | See batch section below |

### Batch APIs in FOLIO (mod-inventory-storage)

FOLIO provides **batch synchronous** endpoints in `mod-inventory-storage` (not `mod-inventory`):

| Endpoint | Module | Behavior | Limit |
|----------|--------|----------|-------|
| `POST /item-storage/batch/synchronous` | mod-inventory-storage | Upsert items in batch; creates if UUID absent, updates if present | Typically 500-1000 records per call |
| `POST /instance-storage/batch/synchronous` | mod-inventory-storage | Upsert instances in batch | Same |
| `POST /holdings-storage/batch/synchronous` | mod-inventory-storage | Upsert holdings in batch | Same |
| `POST /item-storage/batch/synchronous?upsert=true` | mod-inventory-storage | Explicit upsert mode (create or overlay) | Same |

**Batch API Characteristics:**
- Accepts a JSON array of full record objects.
- If `id` (UUID) is provided and exists → overlay/update.
- If `id` is provided and doesn't exist → create with that UUID.
- If `id` is omitted → create with server-generated UUID.
- Returns 201 on full success; 422/500 on failures.
- Optimistic locking via `_version` field (409 on conflict).
- No partial success reporting — entire batch fails or succeeds (some FOLIO versions support partial).

### Recommended API Strategy for Axiell → FOLIO

**Phase 1 (Low volume, simple):**
- Use `GET /inventory/items?query=...` with CQL to find existing item by external identifier.
- Use `POST /inventory/items` for creates.
- Use `PUT /inventory/items/{id}` for updates (full replace after GET).
- Process records sequentially or with bounded concurrency (5-10 parallel).

**Phase 2 (Higher volume, batch):**
- Pre-resolve external IDs to FOLIO UUIDs using a local mapping table.
- Use `POST /item-storage/batch/synchronous?upsert=true` in chunks of 500.
- Maintain a local mapping table: `(axiell_guid → folio_uuid, last_hash, last_version)`.
- Eliminates per-record GET calls after initial sync.

### API Decision Matrix

| Scenario | Recommended API | Why |
|----------|----------------|-----|
| Initial backfill (thousands of records) | Batch sync with upsert=true | Performance; reduces HTTP overhead |
| Incremental run (10-50 records/window) | Individual PUT/POST per record | Simpler error handling per record |
| Partial field update only | PATCH | Avoids overwriting fields managed by other systems |
| Record deletion | PUT with `discoverySuppress=true` or DELETE | Soft-delete preferred to preserve history |

---

## Open Questions

1. Which FOLIO entity path: item only, or instance → holdings → item hierarchy?
2. Should we create holdings/instances if they don't exist, or require pre-existing parent records?
3. What is the canonical external identifier in FOLIO for matching (hrid vs custom field)?
4. Is there a FOLIO sandbox/staging environment available for integration testing?
5. Should the FOLIO upsert be synchronous with the loader step, or asynchronous via EventBridge?
6. What are acceptable latency SLAs between AxC change and FOLIO visibility?
7. Should Phase 1 include deletes, or only creates/updates?
8. Is deterministic UUID5 from Axiell GUID acceptable, or must UUIDs be server-generated?
9. What is the batch size limit on the target FOLIO tenant's `batch/synchronous` endpoint?
10. Which reference data UUIDs (materialType, loanType, locations) are configured in the target FOLIO tenant?
---

## Related Documents

- [Axiell Collections Adapter Guide](axiell_collections_adapter_guide.md)
- [AxC to FOLIO Harvester Flow (Proposed)](axc-to-folio-harvester-flow.md)
- [CALM to Sierra Harvester Flow](calm-to-sierra-harvester-flow.md)

