context("resource_update")

# Use a local example file from package ckanR
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_settings
url <- get_test_url()
key <- get_test_key()
rid <- get_test_rid()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })
test_that("A CKAN resource ID must be set", { expect_is(rid, "character") })

# Test update_resource
test_that("resource_update gives back expected class types and output", {
  check_ckan(url)
  check_resource(url, rid)
  a <- resource_update(id = rid, path = path, url = url, key = key)

  # class types
  expect_is(a, "ckan_resource")
  expect_is(a$id, "character")

  # expected output
  expect_equal(a$id, rid)
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("resource_update fails well", {
  check_ckan(url)
  check_resource(url, rid)

  # all parameters missing
  expect_error(resource_update(), "argument \"id\" is missing, with no default")

  # bad resource id
  expect_error(resource_update("invalid-resource-id", path=path, url=url, key=key),
               "Not Found Error")

  # bad file path: local file does not exist
  expect_error(resource_update(rid, "invalid-file-path", url=url, key=key))

  # bad url
  expect_error(resource_update(rid, path=path, url="invalid-URL", key=key))

  # bad key
  expect_error(resource_update(rid, path=path, url=url, key="invalid-key"),
               "Authorization Error")
})
