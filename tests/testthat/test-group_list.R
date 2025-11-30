context("group_list")

skip_on_cran()

u <- get_test_url()

test_that("group_list supports list/json/table formats", {
  check_ckan(u)
  expect_ckan_formats(function(fmt) {
    group_list(url = u, as = fmt, limit = 10)
  })
})

test_that("group_list fails correctly", {
  check_ckan(u)
  expect_error(group_list(sort = "adf", url = u, limit = 10), "Cannot sort by field `adf`")
  expect_is(group_list(url = u, limit = 10), "list")
})
