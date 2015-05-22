context("changes")

u <- get_test_url()

test_that("changes gives back expected class types", {
  check_ckan()
  a <- changes(url=u)

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$user_id, "character")
  expect_is(a[[1]]$data, "list")
})

test_that("changes works giving back json output", {
  check_ckan()
  b <- changes(url=u, as = 'json')
  b_df <- jsonlite::fromJSON(b)

  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})

test_that("changes fails correctly", {
  check_ckan()

  expect_error(changes("adf"), "offset Invalid integer")
  expect_error(changes(limit = "Adf"), "limit Invalid integer")
  expect_error(changes("adf", url = "http://www.google.com"),
               regexp = "client error: \\(404\\) Not Found")
})
