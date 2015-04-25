context("changes")

test_that("changes gives back expected class types", {
  a <- group_show('childgroup', url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]][[1]]$name, "character")
})

test_that("changes works giving back json output", {
  b <- group_show('childgroup', url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
})

test_that("changes fails correctly", {
  expect_error(group_show("adf"), "message Not found")
  expect_error(group_show(limit = "Adf"), "argument \"id\" is missing")
})
