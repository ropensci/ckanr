context("group_show")

skip_on_cran()

u <- get_test_url()
check_ckan(u)
g <- get_test_gid()
if (g == "") {
  g <- group_list(url = u, limit = 1)[[1]]$name
}

test_that("group_show supports list/json/table formats", {
  if (!ok_group(u, g)) {
    group_create("ckanr_test_group", url = u, key = get_test_key())
  }
  expect_ckan_formats(function(fmt) {
    group_show(g, url = u, as = fmt)
  })
})

test_that("group_show fails correctly", {
  expect_error(group_show("adf", url = u), "404 - Not Found Error")
  expect_error(group_show(limit = "Adf", url = u), "argument \"id\" is missing")
})
