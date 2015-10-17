context("changes")
u <- get_test_url()
g <- get_test_gid()

test_that("changes gives back expected class types", {
  check_ckan(u)
  check_group(u,g)
  a <- group_show(g, url=u)

  expect_is(a, "ckan_group")
  expect_is(a[[1]], "list")
  expect_is(a[[1]][[1]]$name, "character")
})

test_that("changes works giving back json output", {
  check_ckan(u)
  check_group(u,g)
  b <- group_show(g, url=u, as='json')
  b_df <- jsonlite::fromJSON(b)

  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
})

test_that("changes fails correctly", {
  check_ckan(u)
  expect_error(group_show("adf", url=u), "404 - Not Found Error")
  expect_error(group_show(limit = "Adf", url=u), "argument \"id\" is missing")
})
