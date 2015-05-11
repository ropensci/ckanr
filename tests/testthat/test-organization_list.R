context("organization_list")

organization_num <- local({
  res <- httr::GET("http://demo.ckan.org/organization")
  httr::stop_for_status(res)
  html <- httr::content(res, as = "text")
  tmp <- regmatches(html, regexec("(\\d+) organizations found", html))
  as.integer(tmp[[1]][2])
})

test_that("organization_list gives back expected class types", {
  a <- organization_list(url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$state, "character")
  expect_equal(length(a), organization_num)
})

test_that("organization_list works giving back json output", {
  b <- organization_list(url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), organization_num)
})

