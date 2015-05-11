context("resource_show")

test_that("resource_show gives back expected class types", {
  .a <- resource_search("name:data", limit = 1)
  a <- resource_show(.a$results[[1]]$name)
  expect_is(a, "list")
})

test_that("resource_show works giving back json output", {
  .b <- resource_search("name:data", limit = 1)
  b <- resource_show(.b$results[[1]]$name, as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
