context("revision_list")
u <- get_test_url()

test_that("revision_list gives back expected class types", {
  check_ckan(u)
  a <- revision_list(url=u)
  expect_is(a, "list")
})

test_that("revision_list works giving back json output", {
  check_ckan(u)
  b <- revision_list(url=u, as="json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
