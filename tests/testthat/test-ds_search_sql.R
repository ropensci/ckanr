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
  expect_true("records" %in% names(a$result))
  expect_gt(length(a$result$records), 0)
})

test_that("ds_search_sql works giving back json output", {
  check_ckan(u)
  check_resource(u, r)
  if (!ckanr:::ckan_action_available("datastore_search_sql", url = u)) {
    skip("datastore_search_sql action unavailable on this CKAN instance")
  }
  ensure_datastore_records(r)
  sql <- paste0('SELECT * from "', r, '" LIMIT 2')
  b <- ds_search_sql(sql, url = u, as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
  expect_true("result" %in% names(b_df))
})
