context("organization_list")

test_that("organization_list gives back expected class types", {
  a <- organization_list(url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$state, "character")
  expect_equal(length(a), 375)
})

test_that("organization_list works giving back json output", {
  b <- organization_list(url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), 375)
})

