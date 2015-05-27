context("resource_search")
u <- get_test_url()

test_that("resource_search gives back expected class types", {
  check_ckan(u)
  a <- resource_search("name:test", url=u)
  expect_is(a, "list")
})

test_that("resource_search works giving back json output", {
  check_ckan(u)
  b <- resource_search("name:test", url=u, as = "json")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
