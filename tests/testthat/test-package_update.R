context("package_update")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("package_update updates a package", {
  check_ckan(url)

  # Create a package
  pkg_name <- paste0("test_pkg_update_", as.integer(Sys.time()))
  a <- package_create(
    name = pkg_name, title = "Original Title",
    owner_org = oid, url = url, key = key
  )

  # Update it
  update_data <- list(title = "Updated Title", name = pkg_name)
  b <- package_update(update_data, a$id, url = url, key = key)

  expect_is(b, "ckan_package")
  expect_equal(b$id, a$id)
  expect_equal(b$title, "Updated Title")
  expect_equal(b$name, pkg_name)

  # Clean up
  package_delete(a$id, url = url, key = key)
})

test_that("package_update updates multiple fields", {
  check_ckan(url)

  # Create a package
  pkg_name <- paste0("test_pkg_update2_", as.integer(Sys.time()))
  a <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)

  # Update multiple fields
  update_data <- list(
    name = pkg_name,
    title = "New Title",
    author = "New Author",
    notes = "New description"
  )
  b <- package_update(update_data, a$id, url = url, key = key)

  expect_equal(b$title, "New Title")
  expect_equal(b$author, "New Author")
  expect_equal(b$notes, "New description")

  # Clean up
  package_delete(a$id, url = url, key = key)
})

test_that("package_update fails well", {
  check_ckan(url)

  # not a list
  expect_error(package_update("not-a-list", "some-id", url = url, key = key),
               "x must be of class list")

  # invalid id
  expect_error(package_update(list(title = "Test"), "nonexistent-package-id", url = url, key = key),
               "Not Found Error")

  # bad key (use a real package id)
  pkg_name <- paste0("test_pkg_update_badkey_", as.integer(Sys.time()))
  pkg <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)
  expect_error(package_update(list(title = "Test"), pkg$id, url = url, key = "invalid-key"),
               "Authorization Error")
  package_delete(pkg$id, url = url, key = key)
})

test_that("package_update returns json when requested", {
  check_ckan(url)

  # Create a package
  pkg_name <- paste0("test_pkg_update3_", as.integer(Sys.time()))
  a <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)

  # Update and get json
  update_data <- list(title = "JSON Title", name = pkg_name)
  b <- package_update(update_data, a$id, url = url, key = key, as = "json")

  expect_is(b, "character")
  b_parsed <- jsonlite::fromJSON(b)
  expect_is(b_parsed, "list")

  # Clean up
  package_delete(a$id, url = url, key = key)
})
