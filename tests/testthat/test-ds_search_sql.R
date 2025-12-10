context("ds_search_sql")

skip_on_cran()

u <- get_test_url()
r <- get_test_rid()
key <- get_test_key()
path_csv <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
check_ckan(u)

ensure_datastore_records <- function(resource_id) {
  if (!nzchar(resource_id) || !nzchar(key)) {
    return(invisible(FALSE))
  }
  if (!identical(resource_id, get_test_rid())) {
    return(invisible(FALSE))
  }
  helper <- get0("push_resource_to_datastore", inherits = TRUE)
  if (!is.function(helper)) {
    return(invisible(FALSE))
  }
  try(
    helper(
      resource_id = resource_id,
      csv_path = path_csv,
      url = u,
      key = key
    ),
    silent = TRUE
  )
}

# Fallback to external instance if local test instance not configured
# if (u == "" || !ping(u)) {
#   u <- "http://data.nhm.ac.uk/"
#   r <- "8f0784a6-82dd-44e7-b105-6194e046eb8d"
# }

if (r == "") {
  did <- package_list(limit = 1, url = u)[[1]]
  pkg <- package_show(did, url = u)
  r <- pkg$resources[[1]]$id
}
skip_if(r == "")
ensure_datastore_records(r)

test_that("ds_search_sql gives back expected class types", {
  check_ckan(u)
  check_resource(u, r)
  if (!ckanr:::ckan_action_available("datastore_search_sql", url = u)) {
    skip("datastore_search_sql action unavailable on this CKAN instance")
  }
  ensure_datastore_records(r)
  sql <- paste0('SELECT * from "', r, '" LIMIT 2')
  a <- ds_search_sql(sql, url = u)
  expect_is(a, "list")
  # Note: jsl() extracts the 'result' field, so records are at a$records not a$result$records
  records <- a$records
  skip_if(
    is.null(records) || length(records) == 0,
    paste(
      "datastore_search_sql requires rows in the DataStore table (see",
      "https://docs.ckan.org/en/2.9/maintaining/datastore.html#ckanext.datastore.logic.action.datastore_search_sql).",
      "Load fixture data with DataPusher or datastore_create before running this test."
    )
  )
  expect_true("records" %in% names(a))
  expect_gt(length(records), 0)

  expect_ckan_formats(function(fmt) {
    ds_search_sql(sql, url = u, as = fmt)
  })
})
