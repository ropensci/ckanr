context("tag_show")
u <- get_test_url()

tag_test_num <- local({
  res <- httr::GET(file.path(u, "dataset?tags=test&_tags_limit=0"))
  httr::stop_for_status(res)
  html <- httr::content(res, as="text")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("tag_show gives back expected class types", {
  check_ckan(u)
  a <- tag_show("test", include_datasets = TRUE, url=u)

  expect_is(a, "ckan_tag")
  expect_is(a[[2]], "list")
  expect_equal(length(a[[2]]), tag_test_num)
})

test_that("tag_show works giving back json output", {
  check_ckan(u)
  b <- tag_show("test", include_datasets = TRUE, url=u, as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result$packages, "data.frame")
  expect_equal(nrow(b_df$result$packages), tag_test_num)
})

