context("organization_list")

skip_on_cran()

u <- get_test_url()
check_ckan(u)

test_that("organization_list supports list/json/table formats", {
  expect_ckan_formats(function(fmt) {
    organization_list(url = u, as = fmt, limit = 10)
  })
})
