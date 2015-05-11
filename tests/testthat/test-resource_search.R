context("resource_search")

test_that("resource_search gives back expected class types", {
  a <- resource_search("name:data")
  expect_is(a, "list")
})

test_that("resource_search works giving back json output", {
  b <- resource_search("name:data", as = "json")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
