context("organization_delete")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("organization_delete deletes an organization", {
  check_ckan(url)

  # Create an organization to delete
  org_name <- paste0("test_org_delete_", as.integer(Sys.time()))
  org <- organization_create(name = org_name, url = url, key = key)

  # Delete it
  result <- organization_delete(org$id, url = url, key = key)

  expect_true(result)

  # Verify it's deleted (should error)
  expect_error(organization_show(org$id, url = url), "Not Found Error")
})

test_that("organization_delete accepts ckan_organization object", {
  check_ckan(url)

  # Create an organization to delete
  org_name <- paste0("test_org_delete2_", as.integer(Sys.time()))
  org <- organization_create(name = org_name, url = url, key = key)

  # Delete using the ckan_organization object directly
  result <- organization_delete(org, url = url, key = key)

  expect_true(result)
})

test_that("organization_delete fails well", {
  check_ckan(url)

  # missing id
  expect_error(organization_delete(url = url, key = key),
               "argument \"id\" is missing, with no default")

  # invalid id
  expect_error(organization_delete("nonexistent-org-id", url = url, key = key),
               "Not Found Error")

  # bad key
  expect_error(organization_delete("some-id", url = url, key = "invalid-key"),
               "Authorization Error")
})
