context("group_show")

skip_on_cran()

u <- get_test_url()
g <- get_test_gid()
if (g == "") {
  g <- group_list(url = u, limit = 1)[[1]]$name
}

test_that("group_show gives back expected class types", {
  check_ckan(u)
  # check_group(u,g)
  if (!ok_group(u, g))
    group_create("ckanr_test_group", url = u, key = get_test_key())
  a <- group_show(g, url=u)

  expect_is(a, "ckan_group")
  expect_is(a$name, "character")
})

test_that("group_show works giving back json output", {
  check_ckan(u)
  # check_group(u,g)
  if (!ok_group(u, g))
    group_create("ckanr_test_group", url = u, key = get_test_key())
  b <- group_show(g, url=u, as='json')
  b_df <- jsonlite::fromJSON(b)

  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
})

test_that("group_show fails correctly", {
  check_ckan(u)
  expect_error(group_show("adf", url=u), "404 - Not Found Error")
  expect_error(group_show(limit = "Adf", url=u), "argument \"id\" is missing")
})
