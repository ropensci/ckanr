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

test_that("tag_show supports list/json/table formats", {
  t <- tag_list(url = u)[[1]]
  expect_ckan_formats(function(fmt) {
    tag_show(t$name, include_datasets = TRUE, url = u, as = fmt)
  })
})
