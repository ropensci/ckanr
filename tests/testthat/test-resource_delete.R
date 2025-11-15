context("resource_delete")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })
test_that("A CKAN dataset ID must be set", { expect_is(did, "character") })

test_that("resource_delete deletes a resource", {
  check_ckan(url)
  check_dataset(url, did)

  # Create a resource to delete
  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Resource to delete",
    name = "delete_me",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  # Delete it
  result <- resource_delete(res$id, url = url, key = key)

  expect_true(result)

  # Verify it's deleted (should error)
  expect_error(resource_show(res$id, url = url), "Not Found Error")
})

test_that("resource_delete accepts ckan_resource object", {
  check_ckan(url)
  check_dataset(url, did)

  # Create a resource to delete
  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Resource to delete 2",
    name = "delete_me_2",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  # Delete using the ckan_resource object directly
  result <- resource_delete(res, url = url, key = key)

  expect_true(result)
})

test_that("resource_delete fails well", {
  check_ckan(url)

  # missing id
  expect_error(resource_delete(url = url, key = key),
               "argument \"id\" is missing, with no default")

  # invalid id
  expect_error(resource_delete("nonexistent-resource-id", url = url, key = key),
               "Not Found Error")

  # bad key
  expect_error(resource_delete("some-id", url = url, key = "invalid-key"),
               "Authorization Error")
})
