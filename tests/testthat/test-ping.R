context("ping")

skip_on_cran()

test_that("ping returns false when run against non-CKAN URLS", {
  expect_false(ping(url = "http://127.0.0.1:9"))
})

test_that("ping validates `as` and signals on json failure", {
  expect_error(ping(url = "http://127.0.0.1:9", as = "typo"))
  expect_error(ping(url = "http://127.0.0.1:9", as = "json"))
})

test_that("ping return true on non-empty ckanr test URL", {
  skip_on_os("windows")
  skip_on_os("mac")
  u <- get_test_url()
  expect_false(u == "")
  expect_true(ping(url = u))
})
