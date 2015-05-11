context("revision_list")

test_that("revision_list gives back expected class types", {
  a <- revision_list()
  expect_is(a, "list")
})

test_that("revision_list works giving back json output", {
  b <- revision_list(as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
