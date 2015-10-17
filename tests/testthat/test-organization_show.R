context("organization_show")
u <- get_test_url()
o <- get_test_oid()

dataset_num <- local({
  check_ckan(u)
  check_organization(u, o)

  res <- httr::GET(file.path(u, "organization", o))
  httr::stop_for_status(res)
  html <- httr::content(res, as = "text")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("organization_show gives back expected class types", {
  check_ckan(u)
  check_organization(u, o)
  a <- organization_show(o, url=u)

  expect_is(a, "ckan_organization")
  expect_is(a[[1]], "list")
  expect_is(a[[1]][[1]]$name, "character")
  expect_equal(as.integer(length(a)), 19L)

  a <- organization_show(o, url=u, include_datasets = TRUE)
  expect_equal(as.integer(a$package_count), dataset_num)
  expect_equal(as.integer(length(a$packages)), dataset_num)
})

test_that("organization_show works giving back json output", {
  check_ckan(u)
  check_organization(u, o)
  b <- organization_show(o, url=u, as='json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "list")
  expect_equal(as.integer(length(b_df$result)), 19L)
})
