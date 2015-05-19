context("resource_update")

# Use a local example file from package ckanR
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_options
url <- get_test_url()
key <- get_test_key()
rid <- get_test_rid()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })
test_that("A CKAN resource ID must be set", { expect_is(rid, "character") })

# Helper functions to test CKAN environment
check_resource <- function(){
  res <- resource_show(rid, url=url)
  if(class(res)!="list" && res$id!=rid){
   skip(paste("The CKAN test resource wasn't found.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does Resource with ID", rid, "exist on", url, "?"))
  }
}

# Test update_resource
test_that("resource_update gives back expected class types", {
  check_ckan()
  check_resource()
  a <- resource_update(id = rid, path=path, url=url, key=key)
  expect_is(a, "list")
  expect_is(a$id, "character")
})

test_that("resource_update gives back expected output", {
  check_ckan()
  check_resource()
  a <- resource_update(id = rid, path=path, url=url, key=key)
  expect_equal(a$id, rid)
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("resource_update fails well", {
  check_ckan()
  check_resource()

  # all parameters missing
  expect_error(resource_update(), "argument \"path\" is missing, with no default")

  # bad resource id
  expect_error(resource_update("invalid-resource-id", path=path, url=url, key=key),
               "client error")

  # bad file path: local file does not exist
  expect_error(resource_update(rid, "invalid-file-path", url=url, key=key),
               "file does not exist")

  # bad url
  expect_error(resource_update(rid, path=path, url="invalid-URL", key=key),
               "Could not resolve host")

  # bad key
  expect_error(resource_update(rid, path=path, url=url, key="invalid-key"),
               "Forbidden")
})
