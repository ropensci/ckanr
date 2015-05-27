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
  ckanr_setup(url=du)
  expect_equal(get_default_url(), du)
  ckanr_setup(url=x)
  expect_equal(get_default_url(), x)
})

test_that("ckanr_settings can set and get default key", {
  x <- get_default_key()
  ckanr_setup(key=dk)
  expect_equal(get_default_key(), dk)
  ckanr_setup(key=x)
  expect_equal(get_default_key(), x)
})

test_that("ckanr_settings can set and get test url", {
  x <- get_test_url()
  ckanr_setup(test_url=tu)
  expect_equal(get_test_url(), tu)
  ckanr_setup(test_url=x)
  expect_equal(get_test_url(), x)
})

test_that("ckanr_settings can set and get test key", {
  x <- get_test_key()
  ckanr_setup(test_key=tk)
  expect_equal(get_test_key(), tk)
  ckanr_setup(test_key=x)
  expect_equal(get_test_key(), x)
})

test_that("ckanr_settings can set and get test dataset ID", {
  x <- get_test_did()
  ckanr_setup(test_did=td)
  expect_equal(get_test_did(), td)
  ckanr_setup(test_did=x)
  expect_equal(get_test_did(), x)
})

test_that("ckanr_settings can set and get test resource ID", {
  x <- get_test_rid()
  ckanr_setup(test_rid=tr)
  expect_equal(get_test_rid(), tr)
  ckanr_setup(test_rid=x)
  expect_equal(get_test_rid(), x)
})

test_that("ckanr_settings can set and get test_behaviour", {
  x <- get_test_behaviour()
  ckanr_setup(test_behaviour="FAIL")
  expect_equal(get_test_behaviour(), "FAIL")
  ckanr_setup(test_behaviour="SKIP")
  expect_equal(get_test_behaviour(), "SKIP")
  ckanr_setup(test_behaviour=x)
  expect_equal(get_test_behaviour(), x)
})

test_that("ckanr_settings default to set default CKAN URL", {
  # Preserve original setting
  x <- get_default_url()

  # Overwrite the default url
  ckanr_setup(url="totally-not-the-default-URL")

  # Expected: sets default url to the default_ckan
  ckanr_setup()
  expect_equal(get_default_url(), default_ckan)

  # Restore original setting
  ckanr_setup(url=x)
  expect_equal(get_default_url(), x)
})
