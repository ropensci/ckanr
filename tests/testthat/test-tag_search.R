context("tag_search")

test_that("tag_search gives back expected class types", {
  a <- tag_search()
  expect_is(a, "list")
})

test_that("tag_search works giving back json output", {
  b <- tag_search(as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
