context("ds_create_dataset")

# Use a local example file from package ckanR
file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_options
url = get_test_url()
key = get_test_key()
did = get_test_did()

# Dataset fields
ds_title <- "ckanR test resource"

# Test CKAN environment
test_that("The CKAN URL is set", { expect_is(url, "character") })
test_that("The CKAN API key is set", { expect_is(key, "character") })
test_that("The CKAN Dataset ID is set", { expect_is(did, "character") })

# Helper functions to test CKAN environment
check_ckan <- function(){
  if(!ping(url)) {
    skip(paste("CKAN is offline.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does the test CKAN server run at", url, "?"))
  }
}

check_dataset <- function(){
  p <- package_show(did, url=url)
  if(class(p)!="list" && p$id!=did){
    skip(paste("The CKAN test dataset wasn't found.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does a dataset with ID", did, "exist on", url, "?"))
  }
}

# Test ds_dataset_create
test_that("ds_create_dataset gives back expected class types", {
  check_ckan()
  check_dataset()

  a <- ds_create_dataset(package_id=did, name=ds_title, file, key, url)
  expect_is(a, "list")
  expect_is(a$name, "character")
})

test_that("ds_create_dataset gives back expected output", {
  check_ckan()
  check_dataset()

  a <- ds_create_dataset(package_id=did, name=ds_title, file, key, url)
  expect_equal(a$name, ds_title)
  expect_equal(a$format, "CSV")
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("ds_create_dataset fails well", {
  check_ckan()
  check_dataset()

  # all parameters missing
  expect_error(ds_create_dataset(),
               "argument \"path\" is missing, with no default")
  # 403 forbidden error
  expect_error(ds_create_dataset(did, ds_title, file, "badkey", url),
               "Forbidden")
  # bad file path
  expect_error(ds_create_dataset(did, ds_title, "asdfasdf", key, url),
               "file does not exist")
})
