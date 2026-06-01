# Location Movement POC

A proof-of-concept project for testing FOLIO API operations related to location and item movement management.

## Overview

This project provides tools and notebooks for testing FOLIO (Fedora Object Library) API interactions, including:
- Checking item status by barcode or item ID
- Listing patron hold requests by user ID
- Testing location and movement workflows

## Prerequisites

You'll need the following environment variables configured:

- `FOLIO_BASE_URL` (optional, default: `https://api-wellcome.folio.ebsco.com`)
- `FOLIO_TENANT` (required)
- `FOLIO_USERNAME` (required)
- `FOLIO_PASSWORD` (required)

## Setup

### Environment Variables

Copy the example environment file and add your FOLIO API credentials:

```bash
cp .env.example .env
```

Then edit `.env` and fill in your values:
```
FOLIO_TENANT=your_tenant_name
FOLIO_USERNAME=your_username
FOLIO_PASSWORD=your_password
FOLIO_BASE_URL=https://api-wellcome.folio.ebsco.com  # optional
```

The `.env` file is automatically loaded by `uv run` and will be available to notebooks and scripts.

### Using uv (Recommended)

This project uses [uv](https://github.com/astral-sh/uv) for fast, reliable Python dependency management.

Install dependencies:
```bash
uv sync
```

Run a script:
```bash
uv run python script.py
```

## Usage

### Running the Jupyter Notebook

Launch the FOLIO API test notebook:
```bash
jupyter notebook notebooks/folio_api_test_item_status_and_patron_holds.ipynb
```

Set your environment variables before running:
```bash
export FOLIO_TENANT="your_tenant"
export FOLIO_USERNAME="your_username"
export FOLIO_PASSWORD="your_password"
```

## Project Structure

```
location-movement-poc/
├── docs/              # Documentation and discovery notes
├── notebooks/         # Jupyter notebooks for API testing
├── pyproject.toml     # Project metadata and dependencies
└── LICENSE            # Project license
```

## Dependencies

### Core Dependencies
- `requests` - HTTP library for API calls
- `jupyter` - Jupyter notebook environment
- `ipython` - Enhanced Python interactive shell

### Development Dependencies
- `pytest` - Testing framework
- `black` - Code formatter
- `ruff` - Fast Python linter
- `mypy` - Static type checker

## Development

Format code with black:
```bash
uv run black .
```

Lint with ruff:
```bash
uv run ruff check .
```

Run tests:
```bash
uv run pytest
```

## License

See LICENSE file for details.
