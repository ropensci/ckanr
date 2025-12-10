context("changes")

skip_on_cran()

u <- get_test_url()
k <- get_test_key()
check_ckan(u)

test_that("changes gives back expected class types", {
  a <- changes(url = u, key = k)
  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$user_id, "character")
  expect_is(a[[1]]$data, "list")
  expect_ckan_formats(function(fmt) {
    changes(url = u, key = k, as = fmt)
  })
})

test_that("changes fails correctly", {
  expect_error(changes("adf"), "offset Invalid integer")
  expect_error(changes(limit = "Adf"), "limit Invalid integer")
  expect_error(changes("adf", url = "http://www.google.com"), regexp = "404")
})
