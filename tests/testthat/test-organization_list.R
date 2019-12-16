context("organization_list")

skip_on_cran()

u <- get_test_url()

test_that("organization_list gives back expected class types", {
  check_ckan(u)
  a <- organization_list(url=u, limit=10)

  expect_is(a, "list")
  expect_is(a[[1]], "ckan_organization")
  expect_is(a[[1]]$state, "character")
  #expect_equal(as.integer(length(a)), organization_num)
})

test_that("organization_list works giving back json output", {
  b <- organization_list(url=u, as = 'json', limit=10)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  #expect_equal(nrow(b_df$result), organization_num)
})

