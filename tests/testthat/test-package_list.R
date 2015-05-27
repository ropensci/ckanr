context("package_list")
u <- get_test_url()

package_num <- local({
  check_ckan(u)
  res <- httr::GET(file.path(u, "api/3/action/package_list"))
  httr::stop_for_status(res)
  json <- httr::content(res, as="parsed")
  length(json$result)
})

test_that("package_list gives back expected class types", {
  check_ckan(u)
  a <- package_list(url=u, limit=30)
  expect_is(a, "list")
  expect_less_than(length(a), 30 + 1)
  a <- package_list(url=u, limit=NULL)
  expect_is(a, "list")
  expect_equal(length(a), package_num)
})

test_that("package_list works giving back json output", {
  check_ckan(u)
  b <- package_list(url=u, as='json', limit=30)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "character")
  expect_less_than(length(b_df$result), 30 + 1)

  b <- package_list(url=u, as = 'json', limit = NULL)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "character")
  expect_equal(length(b_df$result), package_num)
})

