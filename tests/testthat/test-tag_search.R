context("tag_search")
u <- get_test_url()

test_that("tag_search gives back expected class types", {
  check_ckan(u)
  a <- tag_search(u)
  expect_is(a, "list")
})

test_that("tag_search works giving back json output", {
  check_ckan(u)
  b <- tag_search(url=u, as="json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
