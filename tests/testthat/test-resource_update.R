context("resource_update")

# Use a local example file from package ckanR
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_settings
url <- get_test_url()
key <- get_test_key()
did <- get_test_did()
ds_title <- "ckanR test resource"

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

# Test update_resource
test_that("resource_update gives back expected class types and output", {
  check_ckan(url)
  a0 <- ds_create_dataset(package_id = did, name = ds_title, path, key, url)
  rid <- a0$id
  check_resource(url, rid)
  a <- resource_update(id = rid, path = path, url = url, key = key)

  # class types
  expect_is(a, "ckan_resource")
  expect_is(a$id, "character")

  # expected output
  expect_equal(a$id, rid)
  # expect_true(grepl("actinidiaceae", a$url))
  expect_true(resource_delete(id = rid, url = url, key = key))
})

test_that("resource_update fails well", {
  check_ckan(url)
  p <- package_show(get_test_did(), url = url)
  rid <- p$resources[[1]]$id
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
