context("group_list")

test_that("group_list gives back expected class types", {
  a <- group_list(url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$state, "character")
})

test_that("group_list works giving back json output", {
  b <- group_list(url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})

test_that("group_list fails correctly", {
  expect_error(group_list(sort = "adf"), "Cannot sort by field `adf`")
  expect_equal(group_list(groups = 4), list())
})
