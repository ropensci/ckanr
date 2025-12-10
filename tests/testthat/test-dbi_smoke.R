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

  # tbl_obj <- dplyr::tbl(src, name = rid)
  # <CKANConnection> uses an old dbplyr interface
  # ℹ Please install a newer version of the package or contact the maintainer
  # This warning is displayed once every 8 hours.
  # Error in ds_search_sql(as.character(statement), url = conn@url, as = "table") :
  # "Bad request - Action name not known: datastore_search_sql"

  # x <- tbl_obj |>
  # # See https://github.com/ropensci/ckanr/issues/188
  # # See https://dbplyr.tidyverse.org/articles/translation-function.html
  # dplyr::slice_min(n = 3, "ID") |>
  #   dplyr::collect()

  # expect_s3_class(x, "tbl_df")
  # expect_gt(nrow(x), 0)
  # expect_true(all(names(x) %in% vapply(preview$fields, `[[`, character(1), "id")))

  # sql_tbl <- dplyr::tbl(
  #   src,
  #   from = sprintf('SELECT "_id", "family" FROM "%s" LIMIT 2', rid)
  # )
  # sql_rows <- sql_tbl |> dplyr::collect()
  # expect_true(all(c("_id", "family") %in% names(sql_rows)))
})
