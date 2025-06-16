context("tag_show")

skip_on_cran()
skip_on_ci()

u <- get_test_url()
check_ckan(u)

tag_test_num <- local({
  t <- "api"
  res <- crul::HttpClient$new(file.path(u, "dataset"))$get(
    query = list(tags = t, "_tags_limit" = 0))
  res$raise_for_status()
  html <- res$parse("UTF-8")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("tag_show gives back expected class types", {
  t <- tag_list(url=u)[[1]]
  a <- tag_show(t$name, include_datasets = TRUE, url=u)

  expect_is(a, "ckan_tag")
  expect_is(a[[2]], "list")
  #expect_equal(length(a[[2]]), tag_test_num)
})

test_that("tag_show works giving back json output", {
  t <- tag_list(url=u)[[1]]
  b <- tag_show(t$name, include_datasets = TRUE, url=u, as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  # expect_is(b_df$result$packages, "data.frame")
  #expect_equal(nrow(b_df$result$packages), tag_test_num)
})

