context("license_list")

skip_on_cran()

u <- get_test_url()
check_ckan(u)


test_that("license_list gives back expected type", {
  expect_equal(class(license_list(url=u)), "list")
  expect_equal(class(license_list(url=u, as = "table")), "data.frame")
})
