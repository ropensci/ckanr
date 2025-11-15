# Copilot Instructions for ckanr

## Project Overview

`ckanr` is an R client package for the [CKAN API](https://ckan.org/), enabling R users to interact with CKAN data portals for reading, writing, and managing datasets. The package wraps the entire CKAN REST API with R functions organized by resource type (packages, resources, organizations, groups, users, tags).

**Key Architecture**: Functions follow a consistent pattern using HTTP verb wrappers (`ckan_GET`, `ckan_POST`, `ckan_PATCH`, `ckan_DELETE`) defined in `R/zzz.R` that use `crul::HttpClient` for all API requests. Each CKAN resource type has dedicated S3 classes (e.g., `ckan_package`, `ckan_resource`) with coercion functions (`as.ckan_*`).

## Development Environment

### Dev Container Setup

The project runs in a devcontainer with **dual Docker support**:
- Docker-in-Docker for managing containers from within devcontainer
- Docker-outside-of-Docker (bind mount) accessing host Docker daemon via `unix:///var/run/docker-host.sock`
- A full CKAN test instance orchestrated via `docker-compose-dev.yml` runs at `localhost:5000` alongside PostgreSQL, Redis, Solr, and DataPusher services

**Critical**: Tests depend on a running CKAN instance. The helper function `prepare_test_ckan()` in `tests/testthat/helper-ckanr.R` auto-creates test fixtures (dataset, resource, organization, group) on first run.

### Build Commands

Use `justfile` or Makefile for common tasks:
```bash
just doc          # Document package with roxygen2
just build        # Build package
just test         # Run test suite
just deps         # Install dev dependencies
```

VS Code tasks (Ctrl+Shift+B) also available: "R: Document", "R: Build", "R: Test", "R: Check".

## Code Conventions

### Function Organization Pattern

Functions are grouped by CKAN resource type with consistent naming:
- **Packages (datasets)**: `package_create()`, `package_show()`, `package_list()`, etc. → `ckan_package` class
- **Resources**: `resource_create()`, `resource_show()`, `resource_update()` → `ckan_resource` class
- **Organizations/Groups/Users/Tags**: Similar `<type>_<action>()` pattern

All functions:
1. Accept `url` parameter (defaults to `get_default_url()` from `ckanr_setup()`)
2. Accept `key` parameter for authenticated operations (defaults to `get_default_key()`)
3. Return either JSON, list, or table format via `as` parameter
4. Use roxygen2 templates from `man-roxygen/` for common parameters (`@template args`, `@template key`, `@template paging`)

### HTTP Layer (R/zzz.R)

All API calls flow through `ckan_VERB()` which:
- Constructs URLs as `{base_url}/api/3/action/{method}`
- Handles **dual authentication headers** for CKAN 2.10 (X-CKAN-API-Key) and 2.11+ (Authorization)
- Manages proxy settings via `ckanr_settings_env` environment
- Implements error parsing with `err_handler()` that extracts structured errors from JSON responses

**Pattern for new functions**:
```r
my_function <- function(id, url = get_default_url(), key = get_default_key(), ...) {
  id <- as.ckan_<type>(id, url = url)  # Coerce to proper S3 class
  res <- ckan_GET(url, 'my_action', query = list(id = id$id), key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
```

### S3 Class System

Each CKAN type has:
1. **Coercion function** (`as.ckan_package()`, etc.) that accepts either ID string or existing object
2. **Print method** showing key fields (defined in `R/as-ckan_*.R` files)
3. All constructed via `as_ck(x, class)` helper

This enables **piping workflows**: `package_show("my-dataset") %>% resource_create(name = "data.csv")`

## Testing Architecture

### Test Configuration

Tests use environment variables set via `ckanr_setup()`:
- `CKANR_TEST_URL` - CKAN instance URL (default: localhost:5000)
- `CKANR_TEST_KEY` - Privileged API key for write operations
- `CKANR_TEST_DID`, `CKANR_TEST_RID`, `CKANR_TEST_GID`, `CKANR_TEST_OID` - IDs of test fixtures
- `CKANR_TEST_BEHAVIOUR` - "SKIP" or "FAIL" when CKAN unavailable

**Test Helpers** (`tests/testthat/helper-ckanr.R`):
- `check_ckan(url)` - Skip tests if CKAN offline
- `check_resource(url, id)`, `check_dataset()`, etc. - Verify test fixtures exist
- `prepare_test_ckan()` - Auto-creates test data on fresh CKAN instance

### Writing Tests

Standard pattern:
```r
test_that("function_name works", {
  check_ckan(get_test_url())  # Skip if CKAN offline
  result <- my_function(get_test_did())
  expect_is(result, "ckan_package")
})
```

**CI runs against multiple CKAN versions** (2.9, 2.10, 2.11) using docker-compose in GitHub Actions.

## Special Features

### Data Fetching (ckan_fetch)

`ckan_fetch()` downloads and reads various formats (CSV, Excel, JSON, Parquet, SHP, GeoJSON, ZIP) with auto-detection. Each format uses specific packages:
- CSV: base `read.csv()`
- Excel: `readxl::read_excel()` (multi-sheet support)
- Parquet: `arrow::read_parquet()`
- Spatial: `sf::st_read()` for SHP/GeoJSON
- XML/HTML: `xml2::read_xml()`/`xml2::read_html()`

**Pattern**: Check for suggested packages with `check4X("package_name")` before use.

### DBI/dplyr Integration

`R/dbi.R` and `R/dplyr.R` implement DBI interface for CKAN DataStore:
- `src_ckan(url)` creates a dplyr-compatible connection
- Queries translate to DataStore SQL via `ds_search_sql()`
- Read-only interface (write operations throw `.read_only()` error)

### Roxygen2 Templates

Use templates for consistent documentation:
```r
#' @template args     # url, as, ... parameters
#' @template key      # key parameter
#' @template paging   # offset, limit parameters
```

## Common Pitfalls

1. **Authentication**: Always provide both legacy (X-CKAN-API-Key) and new (Authorization) headers for CKAN version compatibility
2. **URL trailing slashes**: Use `notrail()` helper to strip trailing slashes before API calls
3. **Test dependencies**: Tests requiring write access should check for API key with `check_ckan()` and skip if unavailable
4. **File uploads**: Use multipart encoding, see `resource_create()` for upload pattern
5. **DataStore readiness**: CSV resources need time for DataPusher to load into DataStore; tests may skip if not ready

## Documentation Standards

- All exported functions must have roxygen2 documentation with `@export`
- Use `@importFrom` for specific imports (avoid full package imports)
- Include examples wrapped in `\dontrun{}` (they require live CKAN instance)
- Document return value structure, especially for S3 classes
- Reference related functions with `[function_name()]` markdown links

## CI/CD Notes

- GitHub Actions workflow tests against Windows, macOS, Ubuntu
- Ubuntu tests run against CKAN 2.9, 2.10, 2.11 in docker-compose
- API keys generated via `docker exec ckan ckan user token add` for CKAN 2.9+
- Coverage reported via codecov for Ubuntu R-release + CKAN 2.11 only
