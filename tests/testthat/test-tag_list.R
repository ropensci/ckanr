context("tag_list")

tag_num <- local({
  res <- httr::GET("http://demo.ckan.org/api/3/action/tag_list")
  httr::stop_for_status(res)
  json <- httr::content(res, as = "parsed")
  length(json$result)
})

test_that("tag_list gives back expected class types", {
  a <- tag_list(url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_equal(length(a), tag_num)

})

test_that("tag_list works giving back json output", {
  b <- tag_list(url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), tag_num)
})

