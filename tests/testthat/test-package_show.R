context("package_show")

skip_on_cran()

u <- get_test_url()

test_that("package_show supports list/json/table formats", {
  check_ckan(u)
  pkgs <- package_list(limit = 1, url = u)
  skip_if(length(pkgs) == 0, "No packages available for testing")
  pkg_id <- pkgs[[1]]
  expect_ckan_formats(function(fmt) {
    package_show(pkg_id, url = u, as = fmt)
  })
})
