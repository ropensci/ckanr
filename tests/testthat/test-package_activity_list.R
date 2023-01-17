context("package_activity_list")

skip_on_cran()
skip_on_ci()

u <- get_test_url()
check_ckan(u)

id <- package_list(limit = 1, url=u)[[1]]

package_activity_num <- local({
  res <- crul::HttpClient$new(file.path(u, "dataset/activity", id))$get()
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  length(xml2::xml_find_all(xml2::read_html(txt),
    '//ul[@data-module="activity-stream"]/li'))
})

test_that("package_activity_list gives back expected class types", {

  a <- package_activity_list(id, url=u, limit=30)
  expect_is(a, "list")
  expect_lt(length(a), 30 + 1)
  a <- package_activity_list(id, url=u, limit=NULL)
  expect_is(a, "list")
  expect_equal(length(a), package_activity_num)
})

test_that("package_activity_list works giving back json output", {
  b <- package_activity_list(id, url=u, as='json', limit=30)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_lt(nrow(b_df$result), 30 + 1)

  b <- package_activity_list(id, url=u, as='json', limit=NULL)
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), package_activity_num)
})

