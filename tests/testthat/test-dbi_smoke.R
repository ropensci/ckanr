context("dbi_smoke")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")
testthat::skip_if_not_installed("dplyr")
testthat::skip_if_not_installed("dbplyr")

url <- get_test_url()

skip_if(!nzchar(url), "CKAN test settings not configured")

safe_ds_preview <- function(resource_id, preview_limit = 5) {
  tryCatch(
    ds_search(resource_id = resource_id, limit = preview_limit, url = url),
    error = function(e) e
  )
}

ensure_datastore_sql <- function(resource_id) {
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

find_sql_ready_resource <- function() {
  rid <- get_test_rid()
  if (nzchar(rid)) {
    res <- ensure_datastore_sql(rid)
    if (!inherits(res, "error")) {
      return(rid)
    }
  }

  meta <- try(ds_search("_table_metadata", url = url, as = "table", limit = 50), silent = TRUE)
  if (inherits(meta, "try-error") || !is.list(meta) || is.null(meta$records)) {
    testthat::skip("Unable to list datastore metadata")
  }

  for (name in meta$records$name) {
    res <- ensure_datastore_sql(name)
    if (!inherits(res, "error")) {
      return(name)
    }
  }

  testthat::skip("No datastore resources accept SQL queries in this environment")
}

test_that("src_ckan collects rows from datastore resource", {
  check_ckan(url)
  rid <- find_sql_ready_resource()

  preview <- safe_ds_preview(rid)
  if (inherits(preview, "error") || !is.list(preview) || length(preview$records) == 0) {
    skip("Selected datastore resource did not return preview data")
  }

  src <- src_ckan(url)

  tbl_obj <- dplyr::tbl(src, name = rid)
  sample <- tbl_obj |>
    # This needs an implementation
    # See https://github.com/ropensci/ckanr/issues/188
    # See https://dbplyr.tidyverse.org/articles/translation-function.html
    # dplyr::slice_min(n = 3, "ID") |>
    dplyr::collect()

  expect_s3_class(sample, "tbl_df")
  expect_gt(nrow(sample), 0)
  expect_true(all(names(sample) %in% vapply(preview$fields, `[[`, character(1), "id")))

  sql_tbl <- dplyr::tbl(
    src,
    from = sprintf('SELECT "_id", "family" FROM "%s" LIMIT 2', rid)
  )
  sql_rows <- sql_tbl |> dplyr::collect()
  expect_true(all(c("_id", "family") %in% names(sql_rows)))
})
