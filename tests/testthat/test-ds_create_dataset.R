context("ds_create_dataset")

# Use a local example file from package ckanR
file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_options
url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

# Dataset fields
ds_title <- "ckanR test resource"

# Test CKAN environment
test_that("The CKAN URL is set", { expect_is(url, "character") })
test_that("The CKAN API key is set", { expect_is(key, "character") })
test_that("The CKAN Dataset ID is set", { expect_is(did, "character") })

# Test ds_dataset_create
test_that("ds_create_dataset gives back expected class types and output", {
  check_ckan(url)
  check_dataset(url, did)

  a <- ds_create_dataset(package_id = did, name = ds_title, file, key, url)

  # class types
  expect_is(a, "list")
  expect_is(a$name, "character")

  # expected output
  expect_equal(a$name, ds_title)
  expect_equal(a$format, "CSV")
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("ds_create_dataset fails well", {
  check_ckan(url)
  check_dataset(url, did)

  # all parameters missing
  expect_error(ds_create_dataset(),
               "argument \"path\" is missing, with no default")
  # 403 forbidden error
  expect_error(ds_create_dataset(did, ds_title, file, "badkey", url),
               "Error : 403 - Authorization Error")
  # bad file path
  expect_error(ds_create_dataset(did, ds_title, "asdfasdf", key, url))
})
