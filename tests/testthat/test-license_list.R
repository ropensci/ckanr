context("license_list")
u = get_test_url()

test_that("license_list gives back expected type", {
  check_ckan(u)

  expect_equal(class(license_list(url=u)), "list")
  expect_equal(class(license_list(as = "table")), "data.frame")
})
