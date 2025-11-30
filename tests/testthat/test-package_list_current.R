context("package_list_current")

skip_on_cran()

u <- get_test_url()

test_that("package_list_current gives back expected class types and parameter offset works", {
  check_ckan(u)
  a <- package_list_current(limit = 30, url = u)
  expect_is(a, "list")
  expect_lt(length(a), 30 + 1)
  a2 <- package_list_current(offset = 5, limit = 25, url = u)
  expect_is(a2, "list")
  expect_lt(length(a2), 25 + 1)
  expect_equal(tail(a, -5), a2)
})

test_that("package_list_current supports list/json/table formats", {
  check_ckan(u)
  expect_ckan_formats(function(fmt) {
    package_list_current(url = u, as = fmt, limit = 10)
  })
})
