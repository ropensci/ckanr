context("ping")

test_that("ping return true", {
  expect_true(ping())
})

test_that("ping returns false when run against non-CKAN URLS", {
  expect_false(ping(url = "http://www.google.com"))
})
