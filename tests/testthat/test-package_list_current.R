context("package_list_current")
u <- get_test_url()

test_that("package_list_current gives back expected class types and parameter offset works", {
  check_ckan(u)
  a <- package_list_current(limit=30, url=u)
  expect_is(a, "list")
  expect_less_than(length(a), 30 + 1)
  a2 <- package_list_current(offset=5, limit=25, url=u)
  expect_is(a2, "list")
  expect_less_than(length(a2), 25 + 1)
  expect_equal(tail(a, -5), a2)
})

test_that("package_list_current works giving back json output", {
  check_ckan(u)
  b <- package_list_current(url=u, as='json', limit=30)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_less_than(nrow(b_df$result), 30 + 1)
})
