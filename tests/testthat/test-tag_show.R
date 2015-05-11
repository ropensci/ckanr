context("tag_show")

tag_test_num <- local({
  res <- httr::GET("http://demo.ckan.org/dataset?tags=test&_tags_limit=0")
  httr::stop_for_status(res)
  html <- httr::content(res, as = "text")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("tag_show gives back expected class types", {
  a <- tag_show("test", url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[2]], "list")
  expect_equal(length(a[[2]]), tag_test_num)

})

test_that("tag_show works giving back json output", {
  b <- tag_show("test", url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result$packages, "data.frame")
  expect_equal(nrow(b_df$result$packages), tag_test_num)
})

