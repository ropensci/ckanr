context("ds_create_dataset")

# Use a local example file from package ckanR
file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from global variables - this will vary between testers
# Sys.setenv("ckan.demo.url"="http://my-ckan.org/", "ckan.demo.key"="my-ckan-key")
url <- Sys.getenv("ckan.demo.url")
key <- Sys.getenv("ckan.demo.key")

# Set dataset fields
ds_slug <- "ckanR-test"
ds_title <- "ckanR test"
ds_description <- "A test dataset, created from ckanR's test suite."

# Create dataset
a <- ds_create_dataset(package_id=ds_slug, name=ds_title, path=file, key=key, url=url)

# Test results
test_that("ds_create_dataset gives back expected class types", {
  expect_is(a, "list")
  expect_is(a$resource_group_id, "character")
})

test_that("ds_create_dataset gives back expected output", {
  expect_equal(a$name, ds_title)
  expect_equal(a$format, "CSV")
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("ds_create_dataset fails well", {
  # all parameters missing
  expect_error(ds_create_dataset(), "argument \"path\" is missing, with no default")
  # 403 forbidden error
  expect_error(ds_create_dataset(ds_slug, ds_title, file, "badkey"), "Forbidden")
  # bad file path
  expect_error(ds_create_dataset(ds_slug, ds_title, "asdfasdf", key), "file does not exist")
})
