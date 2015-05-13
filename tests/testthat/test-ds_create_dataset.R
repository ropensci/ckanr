context("ds_create_dataset")

# Use a local example file from package ckanR
file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_options
url = get_test_url()
key = get_test_key()
did = get_test_did()

# Dataset fields
ds_title <- "ckanR test"
ds_description <- "A test dataset, updated from ckanR's test suite."


# Test CKAN environment
test_that("The CKAN URL is set", { expect_is(url, "character") })
test_that("The CKAN API key is set", { expect_is(key, "character") })
test_that("The CKAN Dataset ID is set", { expect_is(did, "character") })

check_ckan <- function(){
  if(!ping(url)) {
    skip(paste0("CKAN is offline. Tests for ds_create_dataset require a live ",
                "CKAN URL, consult ?set_test_env"))
  }
  p <- package_show(did, url=url)

}
check_dataset <- function(){
  p <- package_show(did, url=url)
  if(class(res)!="list"){
    skip(paste0("The CKAN test dataset doesn't seem to exist. Tests for ",
                "ds_dataset_create require an existing CKAN dataset ID. ",
                "consult ?set_test_env"))
  }
}

# Test ds_dataset_create
test_that("ds_create_dataset gives back expected class types", {
  check_ckan()
  check_dataset()

  a <- ds_create_dataset(package_id=did, name=ds_title, file, key, url)
  expect_is(a, "list")
  expect_is(a$resource_group_id, "character")
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
  expect_error(ds_create_dataset(ds_slug, ds_title, "asdfasdf", key, url),
               "file does not exist")
})
