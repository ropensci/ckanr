context("license_list")

test_that("license_list gives back expected type", {
  expect_equal(class(license_list()), "list")
  expect_equal(class(license_list(as = "table")), "data.frame")
})
