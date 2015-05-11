context("package_show")

test_that("package_show gives back expected class types", {
  .a <- package_list(limit = 1)
  a <- package_show(.a[[1]])
  expect_is(a, "list")
})

test_that("package_show works giving back json output", {
  .b <- package_list(limit = 1)
  b <- package_show(.b[[1]], as = "json")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})

