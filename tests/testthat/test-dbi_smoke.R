context("dbi_smoke")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")
testthat::skip_if_not_installed("dplyr")
testthat::skip_if_not_installed("dbplyr")

url <- get_test_url()

skip_if(!nzchar(url), "CKAN test settings not configured")

safe_ds_preview <- function(resource_id, url, preview_limit = 5) {
  tryCatch(
    ds_search(resource_id = resource_id, limit = preview_limit, url = url),
    error = function(e) e
  )
}

ensure_datastore_sql <- function(resource_id, url) {

  sql <- sprintf('SELECT * FROM "%s" LIMIT 1', resource_id)
  res <- tryCatch(
    ds_search_sql(sql, url = url, as = "table"),
    error = function(e) e
  )
  if (inherits(res, "error")) {
    return(res)
  }
  res
}

find_sql_ready_resource <- function(url) {
  rid <- get_test_rid()
  if (!nzchar(rid)) {
    testthat::skip("No test resource ID configured")
  }

 # First check if datastore is enabled at all
  if (!datastore_enabled(url)) {
    testthat::skip("Datastore extension not enabled on test CKAN instance")
  }

  # Check if the test resource is in the datastore
  preview <- safe_ds_preview(rid, url)
  if (inherits(preview, "error")) {
    testthat::skip("Test resource not available in datastore")
  }

  # Check if SQL queries work on this resource
  res <- ensure_datastore_sql(rid, url)
  if (inherits(res, "error")) {
    testthat::skip("Datastore SQL not available for test resource")
  }

  rid
}

test_that("src_ckan collects rows from datastore resource", {
  check_ckan(url)
  rid <- find_sql_ready_resource(url)

  preview <- safe_ds_preview(rid, url)
  if (inherits(preview, "error") || !is.list(preview) || length(preview$records) == 0) {
    skip("Selected datastore resource did not return preview data")
  }

  src <- src_ckan(url)
  class(src)
  expect_s3_class(src, "src_CKANConnection")

  con <- src$con
  expect_equal(dbplyr::dbplyr_edition(con), 2L)
  expect_true(dbExistsTable(con, rid))
  expect_false(dbExistsTable(con, "not-a-datastore-table"))
  field_names <- vapply(preview$fields, `[[`, character(1), "id")
  expect_true(all(dbListFields(con, rid) %in% c(field_names, "_id", "_full_text")))

  tbl_obj <- dplyr::tbl(con, rid)
  rows <- dplyr::collect(head(tbl_obj, 3))
  expect_s3_class(rows, "data.frame")
  expect_gt(nrow(rows), 0)
  expect_true(all(names(rows) %in% c(field_names, "_id", "_full_text")))

  sql_tbl <- dplyr::tbl(
    con,
    from = dbplyr::sql(sprintf('SELECT "_id" FROM "%s" LIMIT 2', rid))
  )
  sql_rows <- dplyr::collect(sql_tbl)
  expect_true("_id" %in% names(sql_rows))
})

test_that("CKAN DBI results follow the DBI lifecycle", {
  check_ckan(url)
  rid <- find_sql_ready_resource(url)
  con <- dbConnect(new("CKANDriver"), url = url, key = get_test_key())
  result <- dbSendQuery(
    con, sprintf('SELECT * FROM "%s" LIMIT 2', rid)
  )
  on.exit(dbClearResult(result), add = TRUE)

  expect_equal(dbGetStatement(result), sprintf(
    'SELECT * FROM "%s" LIMIT 2', rid
  ))
  expect_false(dbHasCompleted(result))
  first <- dbFetch(result, 1)
  expect_equal(nrow(first), 1)
  expect_false(dbHasCompleted(result))
  second <- dbFetch(result)
  expect_equal(nrow(second), 1)
  expect_true(dbHasCompleted(result))
  expect_equal(dbGetRowCount(result), 2)
  expect_equal(nrow(dbColumnInfo(result)), length(names(first)))
  expect_error(dbBind(result, list()), "does not support parameter binding")
})

test_that("CKAN DBI write operations fail clearly", {
  check_ckan(url)
  con <- dbConnect(new("CKANDriver"), url = url, key = get_test_key())
  expect_error(
    dbCreateTable(con, "new-table", fields = list(value = "text")),
    "read-only"
  )
  expect_error(dbBegin(con), "read-only")
})

test_that("DBI quoting and connection methods work across supported CKAN versions", {
  check_ckan(url)
  skip_if_ckan_below(url, "2.9")

  con <- dbConnect(new("CKANDriver"), url = url, key = get_test_key())
  on.exit(dbDisconnect(con), add = TRUE)
  rid <- get_test_rid()

  expect_equal(
    as.character(dbQuoteIdentifier(con, rid)),
    paste0('"', rid, '"')
  )
  expect_equal(
    as.character(dbQuoteIdentifier(con, 'field"name')),
    '"field""name"'
  )
  expect_equal(as.character(dbQuoteString(con, "O'Reilly")), "'O''Reilly'")

  expect_true(is.character(dbListTables(con)))
  expect_true(dbExistsTable(con, rid))
  expect_false(dbExistsTable(con, "not-a-datastore-table"))
  expect_gt(length(dbListFields(con, rid)), 0)
  expect_true(is.data.frame(dbReadTable(con, rid)))
})
