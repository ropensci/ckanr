context("package_search")
u <- get_test_url()

test_that("package_search gives back expected class types", {
  check_ckan(u)
  a <- package_search(rows=10, url=u)
  expect_is(a, "list")
  expect_less_than(length(a$results), 10 + 1)
  a2 <- package_search(rows=length(a$results), url=u)
  expect_is(a2, "list")
  expect_equal(length(a2$results), length(a$results))
})

test_that("package_search works giving back json output", {
  check_ckan(u)
  a <- package_search(rows=10, url=u, as="json")
  a_df <- jsonlite::fromJSON(a)
  expect_is(a, "character")
  expect_is(a_df, "list")
  expect_is(a_df$result$results, "data.frame")
})
