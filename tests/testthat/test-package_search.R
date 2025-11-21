context("package_search")

skip_on_cran()

u <- get_test_url()

test_that("package_search gives back expected class types", {
  check_ckan(u)
  a <- package_search(rows=10, url=u)
  expect_is(a, "list")
  expect_lt(length(a$results), 10 + 1)
  a2 <- package_search(rows=length(a$results), url=u)
  expect_is(a2, "list")
  expect_equal(length(a2$results), length(a$results))
})

test_that("package_search supports list/json/table formats", {
  check_ckan(u)
  expect_ckan_formats(function(fmt) {
    package_search(rows = 10, url = u, as = fmt)
  })
})
