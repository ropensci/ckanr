context("user_list")
u <- get_test_url()

test_that("user_list gives back expected class types", {
  check_ckan(u)
  a <- user_list(u)
  expect_is(a, "list")
})

test_that("user_list works giving back json output", {
  check_ckan(u)
  b <- user_list(as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
