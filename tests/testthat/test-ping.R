context("ping")

skip_on_cran()

u = get_test_url()

test_that("ping returns false when run against non-CKAN URLS", {
  expect_false(ping(url = "http://www.google.com"))
})

check_ckan(u)

test_that("ping return true", {
  expect_true(ping(url = u))
})