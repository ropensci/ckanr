context("tag_list")

skip_on_cran()

u <- get_test_url()

tag_num <- local({
  check_ckan(u)
  res <- crul::HttpClient$new(file.path(u, "api/3/action/tag_list"))$get()
  res$raise_for_status()
  json <- jsonlite::fromJSON(res$parse("UTF-8"), FALSE)
  length(json$result)
})

test_that("tag_list gives back expected class types", {
  check_ckan(u)
  a <- tag_list(url=u)

  expect_is(a, "list")
  expect_is(a[[1]], "ckan_tag")
  expect_equal(length(a), tag_num)

})

test_that("tag_list works giving back json output", {
  check_ckan(u)
  b <- tag_list(url=u, as='json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), tag_num)
})

