context("package_delete")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("package_delete deletes a package", {
  check_ckan(url)

  # Create a package to delete
  pkg_name <- paste0("test_pkg_delete_", as.integer(Sys.time()))
  a <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)

  # Delete it
  result <- package_delete(a$id, url = url, key = key)

  expect_true(result)

  # Verify it's marked as deleted
  deleted_pkg <- package_show(a$id, url = url, key = key)
  expect_equal(deleted_pkg$state, "deleted")
})

test_that("package_delete accepts ckan_package object", {
  check_ckan(url)

  # Create a package to delete
  pkg_name <- paste0("test_pkg_delete2_", as.integer(Sys.time()))
  a <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)

  # Delete using the ckan_package object directly
  result <- package_delete(a, url = url, key = key)

  expect_true(result)
})

test_that("package_delete fails well", {
  check_ckan(url)

  # missing id
  expect_error(package_delete(url = url, key = key),
               "argument \"id\" is missing, with no default")

  # invalid id
  expect_error(package_delete("nonexistent-package-id", url = url, key = key),
               "Not Found Error")
})
