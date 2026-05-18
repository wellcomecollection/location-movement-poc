# Sierra to FOLIO Migration Plan

## Overview

This document maps the current Sierra REST API endpoints (accessed via Wellcome's intermediate APIs) to their FOLIO equivalents, and outlines the migration plan.

### Current Architecture

```
Browser → Content/Identity App → Wellcome APIs → Sierra REST API
                                   ↓
                            Items API (item status)
                            Identity API (holds, patron ops)
```

### Target Architecture

```
Browser → Content/Identity App → Wellcome APIs → FOLIO (Okapi gateway)
                                   ↓
                            mod-inventory (items)
                            mod-circulation / mod-patron (holds)
                            mod-users (patron records)
```

---

## Endpoint Mapping

### 1. Item Availability / Status

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `GET /v5/items/{itemNumber}` | `GET /inventory/items/{itemId}` | mod-inventory |
| — | `GET /item-storage/items/{itemId}` | mod-inventory-storage |
| — | `GET /rtac/{instanceId}` | mod-rtac (real-time availability) |
| — | `GET /rtac-cache/{instanceId}` | mod-rtac-cache |

**Notes:**
- Sierra returns item status (available, checked out, on hold, etc.) and hold count directly on the item record.
- In FOLIO, item status lives on `/inventory/items/{itemId}` in the `status.name` field (e.g. "Available", "Checked out", "In transit", "Awaiting pickup").
- For real-time availability checks (similar to what the Items API does), **mod-rtac** or **mod-rtac-cache** provides real-time availability. The `GET /rtac/{instanceId}` endpoint returns holdings with availability per item—this is the closest equivalent to the current Items API behaviour.
- The **edge-rtac** module (`GET /rtac/{instanceId}`) is the external-facing variant if Wellcome wants to expose availability without direct Okapi access.

**Data mapping:**
| Sierra Field | FOLIO Field |
|---|---|
| Item status code | `item.status.name` |
| Hold count | Check `/circulation/requests?query=(itemId=={itemId})` or via RTAC |
| Location | `item.effectiveLocation.name` |
| Call number | `item.effectiveCallNumberComponents` |
| Suppressed/deleted | `item.discoverySuppress` |

---

### 2. Place Hold Request (Create)

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `POST /v5/patrons/{patronNumber}/holds/requests` | `POST /circulation/requests` | mod-circulation |
| — | `POST /patron/account/{id}/item/{itemId}/hold` | mod-patron / edge-patron |
| — | `POST /patron/account/{id}/instance/{instanceId}/hold` | mod-patron (title-level) |

**Notes:**
- The **mod-patron** interface (`/patron/account/{id}/item/{itemId}/hold`) is the closest equivalent—it's designed for patron-facing applications (like edge-patron) and handles hold placement.
- Alternatively, `POST /circulation/requests` is the lower-level circulation endpoint (used internally).
- FOLIO supports three request types: `Hold`, `Recall`, `Page`.
- For title-level requests, use `/patron/account/{id}/instance/{instanceId}/hold`.
- **Allowed service points** must be fetched first: `GET /patron/account/{id}/item/{itemId}/allowed-service-points` or `GET /circulation/requests/allowed-service-points`.

**Request body mapping (Sierra → FOLIO):**
| Sierra Field | FOLIO Field (mod-circulation) | FOLIO Field (mod-patron) |
|---|---|---|
| `recordType` (item/bib) | `requestType` (Hold/Recall/Page) | Determined by endpoint (item vs instance) |
| `recordNumber` | `itemId` / `instanceId` | Path parameter |
| `pickupLocation` | `pickupServicePointId` | `pickupLocationId` |
| `neededBy` | `requestExpirationDate` | `requestExpirationDate` |
| `note` | `patronComments` | `patronComments` |
| Patron number | `requesterId` (FOLIO user UUID) | Path parameter `{id}` |

---

### 3. List Patron's Holds

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `GET /v5/patrons/{patronNumber}/holds` | `GET /patron/account/{id}` (includes holds) | mod-patron |
| — | `GET /circulation/requests?query=(requesterId=={userId})` | mod-circulation |

**Notes:**
- `GET /patron/account/{id}` returns the patron's full account including `holds`, `loans`, and `charges` in a single response. This is the recommended approach for patron-facing apps.
- The query parameter `includeHolds=true` controls whether holds are included.
- Alternatively, `GET /circulation/requests?query=(requesterId=={userId} and status==Open*)` returns all open requests.

**Response mapping:**
| Sierra Hold Field | FOLIO Hold Field |
|---|---|
| Hold ID | `request.id` |
| Status code (0, b, j, i, t) | `request.status` ("Open - Not yet filled", "Open - Awaiting pickup", "Open - In transit") |
| Pickup location | `request.pickupServicePoint.name` |
| Placed date | `request.requestDate` |
| Not needed after date | `request.requestExpirationDate` |
| Item record number | `request.item.instanceId` / `request.item.itemId` |
| Item title | `request.item.title` |

**Sierra status code → FOLIO status mapping:**
| Sierra Code | Sierra Meaning | FOLIO Status |
|---|---|---|
| `0` | Request processing | `Open - Not yet filled` |
| `b` | Bib hold ready | `Open - Awaiting pickup` |
| `j` | Volume hold ready | `Open - Awaiting pickup` |
| `i` | Item ready | `Open - Awaiting pickup` |
| `t` | In transit | `Open - In transit` |

---

### 4. Cancel/Delete Hold

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `DELETE /v5/patrons/{patronNumber}/holds/requests/{holdId}` | `POST /patron/account/{id}/hold/{holdId}/cancel` | mod-patron |
| — | `POST /circulation/requests/{requestId}/move` | mod-circulation |
| — | `PUT /circulation/requests/{requestId}` (set status=Closed) | mod-circulation |

**Notes:**
- In FOLIO, holds are **cancelled** rather than deleted. The mod-patron endpoint `POST /patron/account/{id}/hold/{holdId}/cancel` is the patron-facing equivalent.
- A cancellation reason ID is required in FOLIO (from `/cancellation-reason-storage/cancellation-reasons`).

---

### 5. Get Patron Record

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `GET /v5/patrons/{patronNumber}` | `GET /users/{userId}` | mod-users |
| — | `GET /patron/account/{id}` | mod-patron |
| — | `GET /bl-users/by-id/{id}` | mod-users-bl (composite) |

**Notes:**
- Sierra patron records map to FOLIO user records in mod-users.
- The patron type (e.g. "Reader", "Staff") maps to FOLIO's `patronGroup` field.
- Barcode in Sierra maps to `user.barcode` in FOLIO.
- Expiration date maps to `user.expirationDate`.

**Field mapping:**
| Sierra Patron Field | FOLIO User Field |
|---|---|
| Patron number | `user.id` (UUID) or `user.externalSystemId` |
| Barcode | `user.barcode` |
| Name | `user.personal.firstName`, `user.personal.lastName` |
| Email | `user.personal.email` |
| Patron type | `user.patronGroup` (UUID → resolved via `/groups/{groupId}`) |
| Expiration date | `user.expirationDate` |
| Blocked | Check `/automated-patron-blocks/{userId}` |

---

### 6. Update Item Location (Staff)

| Sierra Endpoint | FOLIO Equivalent | Module |
|---|---|---|
| `PUT /v5/items/{itemNumber}` (location update) | `PUT /inventory/items/{itemId}` | mod-inventory |
| — | `PUT /item-storage/items/{itemId}` | mod-inventory-storage |

**Notes:**
- In FOLIO, item location is set via `temporaryLocation` or `permanentLocation` fields.
- Location IDs come from `/locations` (mod-inventory-storage).

---

## Authentication Changes

| Sierra | FOLIO |
|---|---|
| OAuth client credentials → bearer token | Okapi tenant + token (`X-Okapi-Tenant`, `X-Okapi-Token`) |
| `X-Wellcome-Caller-ID` header | Standard Okapi headers |
| Single API key | Per-tenant authentication via `/authn/login-with-expiry` |

**FOLIO auth flow:**
1. `POST /authn/login-with-expiry` with username/password → returns access token + refresh token (cookies)
2. All subsequent requests include `X-Okapi-Tenant` and `X-Okapi-Token` headers
3. For external patron access, use **edge modules** (edge-patron, edge-rtac) with API key authentication

---

## Error Code Mapping

| Sierra Error | HTTP Status | FOLIO Equivalent |
|---|---|---|
| Code 131 (hold limit) | 403 | 422 with message about request policy limits |
| Code 132 (already on hold) | 409 | 422 with message "item already requested" |
| Code 404 (not found) | 404 | 404 (standard) |
| Code 929 (duplicate) | 409 | 422 with validation error |

---

## Migration Steps

### Phase 1: Backend Services (Separate Repositories)

The Wellcome intermediary APIs (Items API, Identity/Requests API) need to be updated to call FOLIO instead of Sierra. These live in separate repositories but their interfaces to this frontend should remain stable.

1. **Items API backend** → Replace Sierra item lookup with FOLIO `GET /inventory/items` or `GET /rtac/{instanceId}`
2. **Identity/Requests API backend** → Replace Sierra patron/holds calls with FOLIO mod-patron or mod-circulation

### Phase 2: Data Model Changes (This Repository)

1. **Status code mapping** — Replace Sierra status codes (`0`, `b`, `j`, `i`, `t`) with FOLIO request statuses
   - File: [common/data/microcopy.tsx](common/data/microcopy.tsx) (`sierraStatusCodeToLabel`)
   - File: [common/model/requesting.ts](common/model/requesting.ts) (`RequestItem` type)

2. **Patron identity** — Update Auth0 claims and user model
   - Replace `patron_barcode` / `patron_role` Auth0 claims with FOLIO user data
   - File: [common/model/user.ts](common/model/user.ts)
   - File: [identity/webapp/utils/auth0.ts](identity/webapp/utils/auth0.ts)

3. **Request/hold data model** — Update to match FOLIO response shapes
   - File: [identity/webapp/hooks/useRequestedItems.ts](identity/webapp/hooks/useRequestedItems.ts)
   - File: [content/webapp/views/pages/works/work/WorkDetails/PhysicalItems/](content/webapp/views/pages/works/work/WorkDetails/PhysicalItems/)

### Phase 3: Frontend Adjustments

1. **Pickup locations** → Fetch from `/service-points` or `/patron/account/{id}/item/{itemId}/allowed-service-points`
2. **Item requestability logic** → Update `itemIsRequestable()` in [content/webapp/utils/requesting.ts](content/webapp/utils/requesting.ts) to use FOLIO item statuses
3. **Error handling** → Update error code handling for FOLIO's validation error format

### Phase 4: Configuration

1. Update environment variables (API hosts, keys)
2. Configure FOLIO tenant ID and credentials
3. Set up edge module API keys if using edge-patron/edge-rtac for external access

---

## Key FOLIO Modules Required

| Module | Purpose | Replaces |
|---|---|---|
| **mod-inventory** | Item/holdings/instance management | Sierra item lookup |
| **mod-circulation** | Loans, requests (holds), check-in/out | Sierra holds system |
| **mod-patron** / **edge-patron** | Patron-facing account operations | Sierra patron API |
| **mod-users** | User/patron record management | Sierra patron records |
| **mod-rtac** / **mod-rtac-cache** | Real-time availability check | Items API Sierra queries |
| **mod-patron-blocks** | Patron block checking | Sierra patron blocks |
| **mod-inventory-storage** | Item/holdings storage layer | — |

---

## Risks and Considerations

1. **ID mapping** — Sierra uses numeric patron/item numbers; FOLIO uses UUIDs. A mapping layer or `externalSystemId` field will be needed during/after migration.
2. **Status granularity** — FOLIO has more request statuses than Sierra's simple codes. The UI may benefit from showing more detail.
3. **Service points** — FOLIO requires pickup service point IDs; Sierra uses location codes. Need to map locations.
4. **Title-level requests** — FOLIO natively supports title-level holds via mod-patron, which may simplify current logic.
5. **Patron blocks** — FOLIO has automated patron blocks (mod-patron-blocks) which need to be checked before allowing requests.
6. **Auth model** — Moving from OAuth client credentials + API key to Okapi token-based auth.
7. **Edge modules** — If the frontend needs direct FOLIO access (bypassing Wellcome APIs), edge-patron and edge-rtac provide external-facing endpoints with institutional API key auth.
