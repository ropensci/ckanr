context("ckanr_settings")

du <- 'http://default-ckan.org/'
dk <- 'default-ckan-api-key'
tu <- 'http://test-ckan.org/'
tk <- 'test-ckan-key'
td <- 'test-ckan-package-id'
tr <- 'test-ckan-resource-id'
default_ckan <- "http://data.techno-science.ca/"


test_that("ckanr_settings can set and get default url", {
  setup_ckanr(url=du)
  expect_equal(get_default_url(), du)
})

test_that("ckanr_settings can set and get default key", {
  setup_ckanr(key=dk)
  expect_equal(get_default_key(), dk)
})

test_that("ckanr_settings can set and get test url", {
  setup_ckanr(test_url=tu)
  expect_equal(get_test_url(), tu)
})

test_that("ckanr_settings can set and get test key", {
  setup_ckanr(test_key=tk)
  expect_equal(get_test_key(), tk)
})

test_that("ckanr_settings can set and get test dataset ID", {
  setup_ckanr(test_did=td)
  expect_equal(get_test_did(), td)
})

test_that("ckanr_settings can set and get test resource ID", {
  setup_ckanr(test_rid=tr)
  expect_equal(get_test_rid(), tr)
})

test_that("ckanr_settings default to set default CKAN URL", {
  setup_ckanr(url="totally-not-the-default-URL")
  setup_ckanr()
  expect_equal(get_default_url(), default_ckan)
})
