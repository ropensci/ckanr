context("resource_update")

# Use a local example file from package ckanR
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from global variables - this will vary between testers, run:
# Sys.setenv("ckan.demo.url"="http://my-ckan.org/", "ckan.demo.key"="my-ckan-key")
url <- Sys.getenv("ckan.demo.url")
key <- Sys.getenv("ckan.demo.key")
rid <- Sys.getenv("ckan.demo.resource.id")

# Update resource
a <- resource_update(id = rid, path=path, url=url, key=key)

# Inspect result
test_that("resource_update gives back expected class types", {
  expect_is(a, "list")
  expect_is(a$id, "character")
})

test_that("resource_update gives back expected output", {
  expect_is(a$id, rid)
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("resource_update fails well", {
  # all parameters missing
  expect_error(resource_update(), "argument \"path\" is missing, with no default")

  # bad resource id
  expect_error(resource_update("invalid-resource-id", path=path, url=url, key=key), "client error")

  # bad file path: local file does not exist
  expect_error(resource_update(rid, "invalid-file-path", url=url, key=key), "file does not exist")

  # bad url
  expect_error(resource_update(rid, path=path, url="invalid-URL", key=key), "Could not resolve host")

  # bad key
  expect_error(resource_update(rid, path=path, url=url, key="invalid-key"), "Forbidden")
})
