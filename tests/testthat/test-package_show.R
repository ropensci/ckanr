context("package_show")
u <- get_test_url()

test_that("package_show gives back expected class types", {
  check_ckan(u)
  .a <- package_list(limit=1, url=u)
  a <- package_show(.a[[1]], url=u)
  expect_is(a, "ckan_package")
})

test_that("package_show works giving back json output", {
  check_ckan(u)
  .b <- package_list(limit=1, url=u)
  b <- package_show(.b[[1]], url=u, as="json")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})

