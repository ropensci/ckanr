context("changes")

skip_on_cran()

u <- get_test_url()
check_ckan(u)

# Skip for CKAN >= 2.10
# See https://github.com/ropensci/ckanr/issues/220
ver <- floor(ckan_version(u)$version_num)

test_that("changes gives back expected class types", {
  skip_if(ver > 29, message="ckanr::changes() not supported on CKAN>=2.10")
  cat(u, sep = "\n")
  a <- changes(url = u, key = get_test_key())
  expect_is(a, "list")
  expect_is(a[[1]], "list")
  expect_is(a[[1]]$user_id, "character")
  expect_is(a[[1]]$data, "list")
})

test_that("changes works giving back json output", {
  skip_if(ver > 29, message="ckanr::changes() not supported on CKAN>=2.10")
  b <- changes(url = u, , key = get_test_key(), as = 'json')
  b_df <- jsonlite::fromJSON(b)

  expect_is(b, "character")
  expect_is(b_df, "list")
  expect_is(b_df$result, "data.frame")
})

test_that("changes fails correctly", {

  expect_error(changes("adf"), "offset Invalid integer")
  expect_error(changes(limit = "Adf"), "limit Invalid integer")
  expect_error(changes("adf", url = "http://www.google.com"), regexp = "404")
})

test_that("changes returns error for CKAN >= 2.10", {
  skip_if(ver <= 29, message="CKAN version < 2.10")
  expect_error(changes(url = u, key = get_test_key()),
               "ckanr::changes() is not supported on CKAN >= 2.10")
})
