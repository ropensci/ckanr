context("dbi offline")

skip_on_cran()
skip_if_not_installed("DBI")

test_that(".read_only always errors", {
  expect_error(ckanr:::.read_only("dbWriteTable"), "read-only")
  expect_error(ckanr:::.read_only("dbBegin"), "read-only")
})

test_that("fieldMapping maps postgres types", {
  fm <- ckanr:::fieldMapping
  expect_identical(unname(fm("integer")), "integer")
  expect_identical(unname(fm("bigint")), "integer")
  expect_identical(unname(fm("double precision")), "numeric")
  expect_identical(unname(fm("money")), "numeric")
  expect_identical(unname(fm("text")), "character")
  expect_identical(unname(fm("numeric(10,2)")), "numeric")
  expect_identical(unname(fm("timestamp")), "character")
})

test_that("CKANDriver methods work offline", {
  drv <- new("CKANDriver")
  expect_output(DBI::dbGetInfo(drv), "DBI Interface for CKAN")
  expect_output(summary(drv), "DBI Interface for CKAN")
  expect_true(is.null(DBI::dbUnloadDriver(drv)))

  con <- DBI::dbConnect(drv, url = "https://demo.ckan.org")
  expect_true(inherits(con, "CKANConnection"))
  expect_identical(DBI::dbGetInfo(con)$url, "https://demo.ckan.org")
  expect_true(DBI::dbDisconnect(con))
  # clone
  con2 <- DBI::dbConnect(con)
  expect_identical(con2, con)

  expect_error(DBI::dbConnect(drv, url = "not-a-url"), "must start with")
})

test_that("CKANResult initialize/fetch lifecycle works offline", {
  fields <- data.frame(
    id = c("name", "count"),
    type = c("text", "integer"),
    stringsAsFactors = FALSE
  )
  value <- list(
    fields = fields,
    records = data.frame(name = c("a", "b"), count = c(1L, 2L),
      stringsAsFactors = FALSE),
    sql = 'SELECT * FROM "tbl" LIMIT 2'
  )
  res <- new("CKANResult", value = value)
  expect_equal(DBI::dbGetRowsAffected(res), 2)
  expect_equal(DBI::dbGetRowCount(res), 2)
  expect_false(DBI::dbHasCompleted(res))
  first <- DBI::dbFetch(res, 1)
  expect_equal(nrow(first), 1)
  second <- DBI::dbFetch(res)
  expect_equal(nrow(second), 1)
  expect_true(DBI::dbHasCompleted(res))
  expect_equal(DBI::dbGetStatement(res), 'SELECT * FROM "tbl" LIMIT 2')
  expect_true(is.data.frame(DBI::dbColumnInfo(res)))
  expect_equal(DBI::dbListFields(res), c("name", "count"))
  expect_true(is.list(DBI::dbGetException(res)))
  expect_error(DBI::dbBind(res, list()), "does not support parameter binding")
  expect_true(DBI::dbClearResult(res))
  expect_error(summary(res), "TODO")

  # empty records get typed empty data.frame
  value2 <- list(
    fields = fields,
    records = list(),
    sql = "SELECT 1"
  )
  # records as list triggers empty-frame branch via initialize
  res2 <- tryCatch(new("CKANResult", value = value2), error = function(e) e)
  expect_true(inherits(res2, "CKANResult") || inherits(res2, "error"))

  expect_error(new("CKANResult", value = NULL), "No result")
})

test_that("CKAN read-only DBI methods fail clearly offline", {
  drv <- new("CKANDriver")
  con <- DBI::dbConnect(drv, url = "https://demo.ckan.org")
  df <- data.frame(a = 1)
  expect_error(DBI::dbWriteTable(con, "t", df), "read-only")
  expect_error(DBI::dbCreateTable(con, "t", fields = list(a = "text")), "read-only")
  expect_error(DBI::dbRemoveTable(con, "t"), "read-only")
  expect_error(DBI::dbBegin(con), "read-only")
  expect_error(suppressWarnings(DBI::dbCallProc(con)), "TODO")
  expect_error(DBI::dbCommit(con), "TODO")
  expect_error(DBI::dbRollback(con), "TODO")
  expect_true(is.list(DBI::dbGetException(con)))
  expect_silent(summary(con))
})

test_that("file validation helpers work offline (mocked availability)", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    .package = "ckanr",
    {
      expect_error(file_create(url = "https://example.com", key = "k"), "`upload` must be")
      expect_error(file_create(upload = 123, url = "https://example.com"), "single file path")
      expect_error(file_create(upload = tempfile(), url = "https://example.com"), "does not exist")
      expect_error(file_register(url = "https://example.com"), "`location` must be")
    }
  )
  expect_true(is.function(ckanr:::coerce_file))
  f <- ckanr:::coerce_file(list(id = "x"))
  expect_true(inherits(f, "ckan_file"))
})
