context("get_ckanr_url")

test_that("default get_ckanr_url is demo site of ckan", {
  expect_equal(get_ckanr_url(), "http://data.techno-science.ca/")
})

test_that("set_ckanr_url correctly functions", {
  original_url <- get_ckanr_url()
  set_ckanr_url(changed_url <- "http://www.google.com")
  expect_equal(get_ckanr_url(), changed_url)
  set_ckanr_url(original_url)
  expect_equal(get_ckanr_url(), original_url)
})

test_that("Directly set the options", {
  original_url <- get_ckanr_url()
  expect_equal(Sys.getenv("CKANR_DEFAULT_URL"), original_url)
  changed_url <- "http://www.google.com"
  Sys.setenv(CKANR_DEFAULT_URL = changed_url)
  expect_equal(get_ckanr_url(), changed_url)
  Sys.setenv(CKANR_DEFAULT_URL = original_url)
  expect_equal(get_ckanr_url(), original_url)
})

