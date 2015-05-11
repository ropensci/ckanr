context("ping")

test_that("ping return true", {
  expect_true(ping())
})

test_that("ping return false otherwise instead of throwing error", {
  expect_false(ping(url = "http://www.google.com"))
})
