context("group_list")
u <- get_test_url()

test_that("group_list gives back expected class types", {
  check_ckan(u)
  a <- group_list(url=u)

  expect_is(a, "list")
  expect_is(a[[1]], "ckan_group")
  expect_is(a[[1]]$state, "character")
})

test_that("group_list works giving back json output", {
  check_ckan(u)
  b <- group_list(url=u, as='json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})

test_that("group_list fails correctly", {
  check_ckan(u)
  expect_error(group_list(sort = "adf", url=u), "Cannot sort by field `adf`")
  expect_equal(group_list(groups = 4, url=u), list())
})
