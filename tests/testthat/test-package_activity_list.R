context("package_activity_list")

id <- package_list(url = "http://demo.ckan.org", limit = 1)

package_activity_num <- local({
  res <- httr::GET(sprintf("http://demo.ckan.org/dataset/activity/%s", id))
  httr::stop_for_status(res)
  html <- httr::content(res, as = "parsed")
  length(XML::xpathApply(html, '//ul[@data-module="activity-stream"]/li'))
})

test_that("package_activity_list gives back expected class types", {

  a <- package_activity_list(id, url = "http://demo.ckan.org", limit = 30)
  expect_is(a, "list")
  expect_less_than(length(a), 30 + 1)
  a <- package_activity_list(id, url = "http://demo.ckan.org", limit = NULL)
  expect_is(a, "list")
  expect_equal(length(a), package_activity_num)
})

test_that("package_activity_list works giving back json output", {
  b <- package_activity_list(id, url = "http://demo.ckan.org", as = 'json', limit = 30)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_less_than(nrow(b_df$result), 30 + 1)

  b <- package_activity_list(id, url = "http://demo.ckan.org", as = 'json', limit = NULL)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), package_activity_num)
})

