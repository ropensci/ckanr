context("group_list")

skip_on_cran()

# u <- get_test_url()
u <- "http://www.civicdata.io"

test_that("group_list gives back expected class types", {
  check_ckan(u)
  a <- group_list(url=u)

  expect_is(a, "list")
  expect_is(a[[1]], "ckan_group")
  expect_is(a[[1]]$state, "character")
})

test_that("group_list works giving back json output", {
  check_ckan(u)
  b <- group_list(url=u, as='json', limit=10)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
})

test_that("group_list fails correctly", {
  check_ckan(u)
  expect_error(group_list(sort = "adf", url=u, limit=10), "Cannot sort by field `adf`")
  expect_equal(group_list(groups = 4, url=u, limit=10), list())
})
