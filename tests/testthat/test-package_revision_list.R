context("package_revision_list")

test_that("package_revision_list gives back expected class types", {
  .a <- package_list_current(limit = 1)
  a <- package_revision_list(.a[[1]]$id)
  expect_is(a, "list")
})

test_that("package_revision_list works giving back json output", {
  .b <- package_list_current(limit = 1)
  b <- package_revision_list(.b[[1]]$id, as = "json")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})
