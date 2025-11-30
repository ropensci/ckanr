context("ping")

skip_on_cran()

test_that("ping returns false when run against non-CKAN URLS", {
  expect_false(ping(url = "http://www.google.com"))
})

test_that("ping return true on non-empty ckanr test URL", {
  skip_on_os("windows")
  skip_on_os("mac")
  u <- get_test_url()
  expect_false(u == "")
  expect_true(ping(url = u))
})
