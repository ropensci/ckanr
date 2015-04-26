context("organization_show")

test_that("organization_show gives back expected class types", {
  a <- organization_show('03f23a29-906c-45ad-8f77-845a219aa111', url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]][[1]]$name, "character")
  expect_equal(length(a), 19L)
})

test_that("organization_show works giving back json output", {
  b <- organization_show('03f23a29-906c-45ad-8f77-845a219aa111', url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
  expect_equal(length(b_df$result), 19L)
})
