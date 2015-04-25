context("changes")

test_that("changes gives back expected class types", {
  a <- changes(url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$user_id, "character")
  expect_is(a[[1]]$data, "list")
})

test_that("changes works giving back json output", {
  b <- changes(url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})

test_that("changes fails correctly", {
  expect_error(changes("adf"), "offset Invalid integer")
  expect_error(changes(limit = "Adf"), "limit Invalid integer")
})
