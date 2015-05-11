context("user_list")

test_that("user_list gives back expected class types", {
  a <- user_list()
  expect_is(a, "list")
})

test_that("user_list works giving back json output", {
  b <- user_list(as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
