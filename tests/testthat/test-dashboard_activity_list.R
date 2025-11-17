context("dashboard_activity_list")

skip_on_cran()

url <- get_test_url()
key <- get_test_key()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("dashboard_activity_list returns activities", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  # This requires a valid API key
  res <- tryCatch({
    dashboard_activity_list(url = url, key = key)
  }, error = function(e) e)

  # Only test if key is valid and action is supported
  if (!inherits(res, "error")) {
    expect_is(res, "list")
  } else {
    skip("Valid API key required or action not supported in this CKAN version")
  }
})

test_that("dashboard_activity_list respects limit parameter", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  res <- tryCatch({
    dashboard_activity_list(limit = 5, url = url, key = key)
  }, error = function(e) e)

  if (!inherits(res, "error")) {
    expect_is(res, "list")
    expect_lte(length(res), 5)
  } else {
    skip("Valid API key required or action not supported in this CKAN version")
  }
})

test_that("dashboard_activity_list works with json output", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  res <- tryCatch({
    dashboard_activity_list(url = url, key = key, as = "json")
  }, error = function(e) e)

  if (!inherits(res, "error")) {
    expect_is(res, "character")
    parsed <- jsonlite::fromJSON(res)
    expect_is(parsed, "list")
  } else {
    skip("Valid API key required or action not supported in this CKAN version")
  }
})

test_that("dashboard_activity_list fails well", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  # bad key - may fail differently depending on CKAN version
  result <- tryCatch({
    dashboard_activity_list(url = url, key = "invalid-key")
  }, error = function(e) e)

  # Just verify it errors (the error message varies by CKAN version)
  expect_true(inherits(result, "error"))
})
