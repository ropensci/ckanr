context("tag_search")
u <- get_test_url()

test_that("tag_search gives back expected class types", {
  check_ckan(u)
  a <- tag_search(query = "a", url = u)
  expect_is(a, "list")
  expect_is(a[[1]], "ckan_tag")
  expect_named(a[[1]], c('vocabulary_id', 'id', 'name'))
})

test_that("tag_search works giving back json output", {
  check_ckan(u)
  b <- tag_search(url=u, as="json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
