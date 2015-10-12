context("organization_list")
u <- get_test_url()

organization_num <- local({
  check_ckan(u)
  res <- httr::GET(file.path(u, "organization"))
  httr::stop_for_status(res)
  html <- httr::content(res, as = "text")
  tmp <- regmatches(html, regexec("(\\d+) organizations found", html))
  as.integer(tmp[[1]][2])
})

test_that("organization_list gives back expected class types", {
  check_ckan(u)
  a <- organization_list(url=u)

  expect_is(a, "list")
  expect_is(a[[1]], "ckan_organization")
  expect_is(a[[1]]$state, "character")
  expect_equal(as.integer(length(a)), organization_num)
})

test_that("organization_list works giving back json output", {
  b <- organization_list(url=u, as = 'json')
  b_df <- jsonlite::fromJSON(b)
  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
  expect_equal(nrow(b_df$result), organization_num)
})

