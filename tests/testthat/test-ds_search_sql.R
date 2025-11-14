context("ds_search_sql")

skip_on_cran()

u <- get_test_url()
r <- get_test_rid()
check_ckan(u)

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

test_that("ds_search_sql gives back expected class types", {
  check_ckan(u)
  check_resource(u, r)
  # Check if resource is in datastore, skip if not
  test_result <- tryCatch(ds_search(resource_id = r, url = u, limit = 1),
    error = function(e) NULL
  )
  if (is.null(test_result)) {
    skip("Resource not yet in datastore (DataPusher may still be processing)")
  }
  sql <- paste0('SELECT * from "', r, '" LIMIT 2')
  a <- ds_search_sql(sql, url = u)
  expect_is(a, "list")
})

test_that("ds_search_sql works giving back json output", {
  check_ckan(u)
  check_resource(u, r)
  # Check if resource is in datastore, skip if not
  test_result <- tryCatch(ds_search(resource_id = r, url = u, limit = 1),
    error = function(e) NULL
  )
  if (is.null(test_result)) {
    skip("Resource not yet in datastore (DataPusher may still be processing)")
  }
  sql <- paste0('SELECT * from "', r, '" LIMIT 2')
  b <- ds_search_sql(sql, url = u, as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
