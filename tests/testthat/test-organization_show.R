context("organization_show")

target <- "znew-organization-xyz"
dataset_num <- local({
  res <- httr::GET(paste0("http://demo.ckan.org/organization/", target))
  httr::stop_for_status(res)
  html <- httr::content(res, as = "text")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("organization_show gives back expected class types", {
  a <- organization_show('znew-organization-xyz', url = "http://demo.ckan.org")

  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]][[1]]$name, "character")
  expect_equal(length(a), 19L)

  a <- organization_show('znew-organization-xyz', url = "http://demo.ckan.org", include_datasets = TRUE)
  expect_equal(a$package_count, dataset_num)
  expect_equal(length(a$packages), dataset_num)
})

test_that("organization_show works giving back json output", {
  b <- organization_show('znew-organization-xyz', url = "http://demo.ckan.org", as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
  expect_equal(length(b_df$result), 19L)
})
