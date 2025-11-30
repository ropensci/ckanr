context("user_list")

skip_on_cran()

u <- get_test_url()

test_that("user_list supports all as formats", {
  check_ckan(u)
  expect_ckan_formats(function(fmt) {
    user_list(url = u, key = get_test_key(), as = fmt)
  })
})
