# TODO: New dbplyr Interface for the DataStore

The current interface in `R/dbi.R` and `R/dplyr.R` uses the dbplyr 1st-edition
API. Current dbplyr releases require the 2nd-edition API. The existing
interface fails with:

```text
<CKANConnection> uses dbplyr's 1st edition interface
```

The DataStore accepts SQL through `datastore_search_sql`, but it supports only
a read-only subset of PostgreSQL. The backend must generate SQL that the
DataStore accepts and must report unsupported operations clearly.

Use the current dbplyr backend guide as the design reference:
<https://dbplyr.tidyverse.org/articles/new-backend.html>.

## Decisions to make first

- [x] Test with the current dbplyr release, currently `2.6.0`, and set the
  minimum dependency to the first release that supports all methods used by
  the backend. Do not require the newest release without a compatibility
  reason.
- [x] Decide whether `src_ckan()` remains a compatibility wrapper or becomes
  a connection factory. The primary new interface must be
  `dplyr::tbl(conn, "resource-id")`.
- [ ] Decide whether `collect()` returns the DataStore `_id` column. Document
  the decision and test it.
- [x] Define the supported SQL subset. At minimum, document that the backend
  is read-only and that `copy_to()`, `compute()`, table creation, and table
  writes are unsupported.

## Phase 0: DBI Foundation

- [ ] Inventory every DBI method required by `dbplyr` 2.6.0. Do not remove
  existing methods until equivalent 2nd-edition behavior passes.
- [x] Add `dbplyr (>= <tested-minimum>)` to `DESCRIPTION`.
- [x] Fix `dbListTables()` to use the DBI generic signature. Keep paging in a
  private helper instead of adding a public `limit` argument to the method.
- [x] Implement `dbExistsTable()` with `_table_metadata` lookup and return one
  logical value without hiding network errors.
- [x] Implement `dbListFields()` with `datastore_info` or a zero-row query.
  Prefer the action that returns field metadata without executing user SQL.
- [ ] Implement `dbQuoteIdentifier()` and `dbQuoteString()` if DBI defaults do
  not quote resource IDs and values correctly.
- [x] Review `CKANResult` against the DBI result lifecycle. Implement and test
  `dbSendQuery()`, `dbFetch()`, `dbClearResult()`, `dbHasCompleted()`,
  `dbGetRowCount()`, `dbGetRowsAffected()`, `dbColumnInfo()`, and
  `dbGetStatement()` together.
- [x] Make `dbGetQuery()` clear its result and use the same fetch path as
  `dbSendQuery()`.
- [ ] Verify `dbConnect()`, `dbDisconnect()`, `dbListTables()`,
  `dbExistsTable()`, `dbListFields()`, and `dbReadTable()` against CKAN 2.9,
  2.10, 2.11, and 2.12 where CI services are available.

## Phase 1: Declare the dbplyr 2nd Edition

- [x] Add `dbplyr_edition.CKANConnection()` returning `2L`.
- [x] Add `sql_dialect.CKANConnection()` with `new_sql_dialect()` and a
  stable dialect name such as `"ckan"`.
- [ ] Use `DBI::dbQuoteIdentifier()` in the dialect instead of interpolating
  resource IDs into SQL.
- [x] Add `db_connection_describe.CKANConnection()` for connection display.
- [ ] Create a minimal end-to-end test for
  `dplyr::tbl(conn, resource_id) |> dplyr::head() |> dplyr::collect()`.
- [x] Checkpoint: the minimal query renders SQL and returns rows through
  `datastore_search_sql` on CKAN 2.12.

## Phase 2: Port SQL Translation

- [x] Replace `sql_translate_env()` with
  `sql_translation.sql_dialect_ckan()`.
- [x] Define separate `scalar`, `aggregate`, and `window` translators using
  current dbplyr helpers.
- [x] Port the existing custom translations: `corr`, `covar_samp`, `sd`,
  `var`, `all`, `any`, and `paste`.
- [ ] Add `sql_not_supported()` entries for functions that the DataStore
  cannot execute. Do not silently translate unsupported R functions.
- [ ] Test `filter()`, `select()`, `mutate()`, `arrange()`, `summarise()`,
  `group_by()`, joins, set operations, and `distinct()` with
  `show_query()` plus execution.
- [ ] Test every custom translation against `datastore_search_sql` instead of
  assuming that PostgreSQL support means DataStore support.

## Phase 3: Port SQL Query Methods

- [x] Replace `db_query_fields()` with `sql_query_fields()`. Return SQL only
  and let dbplyr execute it.
- [x] Replace `db_explain()` with `sql_query_explain()`. Test whether the
  DataStore accepts `EXPLAIN`. If it does not, return a clear unsupported
  error.
- [ ] Review `sql_query_select()`, `sql_query_join()`, `sql_query_semi_join()`,
  `sql_query_set_op()`, and `sql_query_wrap()` against generated DataStore
  SQL. Add methods only when the default SQL is invalid.
- [x] Remove obsolete `sql_translate_env()`, `src_dbi()`, and `tbl_sql()`
  methods only after all 2nd-edition tests pass.
- [x] Keep `src_ckan()` and `tbl.src_ckan()` during the migration. Add a NEWS
  entry before changing or deprecating their return classes.
- [x] Checkpoint: filtered, selected, mutated, grouped, summarized, joined,
  and distinct queries execute through the new interface.

## Phase 4: Read-Only Behavior

- [x] Make `dbWriteTable()`, `dbRemoveTable()`, `dbCreateTable()`, and related
  write methods fail with the existing read-only error.
- [x] Make `copy_to()` and `compute()` fail before sending unsupported DDL.
  Use the appropriate current dbplyr SQL generation hook, such as
  `sql_query_save()`, after confirming its dispatch in dbplyr 2.6.0.
- [x] Make `dbBind()` fail clearly because `datastore_search_sql` does not
  provide DBI parameter binding.
- [x] Confirm that `collect()` sends only read queries and does not create
  temporary tables.
- [ ] Document result-size limits and recommend `filter()`, `head()`, or
  explicit pagination before collecting large tables.

## Phase 5: Tests, CI, and Documentation

- [x] Replace the current skipped `test-dplyr.R` tests with tests for the
  connection-first interface. Gate them on CKAN availability, datastore
  availability, and CKAN version 2.9 or newer.
- [x] Add tests for DBI result lifecycle, SQL rendering, supported verbs,
  unsupported writes, quoting, errors, and output shape.
- [ ] Add a small local mock or recorded-response layer for SQL rendering
  tests that do not need a running CKAN service.
- [ ] Run the live backend tests against every CKAN version in
  `.github/workflows/R-check.yaml` where the DataStore supports the action.
- [x] Set `TEST_DPLYR_INTERFACE=1` in the relevant CI job so the tests run.
- [x] Update `src_ckan()` roxygen documentation and the vignette with the new
  `dplyr::tbl(conn, "resource-id")` pattern.
- [x] Document the read-only limits and unsupported operations.
- [x] Add a `NEWS.md` entry for the new interface and any compatibility change.
- [ ] Run `devtools::document()`, `just lint`, the targeted tests, the full
  test suite, and `R CMD check`.

## Acceptance Criteria

- [ ] `dplyr::tbl(conn, "resource-id")` works with current dbplyr.
- [ ] `collect()` and the supported dplyr verbs work against CKAN 2.9 through
  2.12.
- [ ] Unsupported writes fail before an invalid request reaches CKAN.
- [ ] Existing `src_ckan()` users receive either unchanged behavior or a
  documented deprecation path.
- [ ] The test suite covers both generated SQL and live DataStore execution.
- [ ] `R CMD check` has no errors or warnings caused by this change.

## Known Risks

- `datastore_search_sql` can reject valid PostgreSQL SQL. Test generated SQL
  through the DataStore rather than relying on PostgreSQL compatibility.
- DBI and dbplyr method signatures can change across package versions. Test
  against the minimum supported dbplyr and the current release.
- DataStore results can be large. Server-side pagination is a separate task
  unless the first implementation needs it for correctness.
