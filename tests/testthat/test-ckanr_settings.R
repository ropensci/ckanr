context("ckanr_settings")

du <- 'http://default-ckan.org/'
dk <- 'default-ckan-api-key'
tu <- 'http://test-ckan.org/'
tk <- 'test-ckan-key'
td <- 'test-ckan-package-id'
tr <- 'test-ckan-resource-id'
default_ckan <- "http://data.techno-science.ca/"


test_that("ckanr_settings can set and get default url", {
  x <- get_default_url()
  setup_ckanr(url=du)
  expect_equal(get_default_url(), du)
  setup_ckanr(url=x)
  expect_equal(get_default_url(), x)
})

test_that("ckanr_settings can set and get default key", {
  x <- get_default_key()
  setup_ckanr(key=dk)
  expect_equal(get_default_key(), dk)
  setup_ckanr(key=x)
  expect_equal(get_default_key(), x)
})

test_that("ckanr_settings can set and get test url", {
  x <- get_test_url()
  setup_ckanr(test_url=tu)
  expect_equal(get_test_url(), tu)
  setup_ckanr(test_url=x)
  expect_equal(get_test_url(), x)
})

test_that("ckanr_settings can set and get test key", {
  x <- get_test_key()
  setup_ckanr(test_key=tk)
  expect_equal(get_test_key(), tk)
  setup_ckanr(test_key=x)
  expect_equal(get_test_key(), x)
})

test_that("ckanr_settings can set and get test dataset ID", {
  x <- get_test_did()
  setup_ckanr(test_did=td)
  expect_equal(get_test_did(), td)
  setup_ckanr(test_did=x)
  expect_equal(get_test_did(), x)
})

test_that("ckanr_settings can set and get test resource ID", {
  x <- get_test_rid()
  setup_ckanr(test_rid=tr)
  expect_equal(get_test_rid(), tr)
  setup_ckanr(test_rid=x)
  expect_equal(get_test_rid(), x)
})

test_that("ckanr_settings default to set default CKAN URL", {
  # Preserve original setting
  x <- get_default_url()

  # Overwrite the default url
  setup_ckanr(url="totally-not-the-default-URL")

  # Expected: sets default url to the default_ckan
  setup_ckanr()
  expect_equal(get_default_url(), default_ckan)

  # Restore original setting
  setup_ckanr(url=x)
  expect_equal(get_default_url(), x)
})
