context("package_create")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("package_create creates a package with minimal parameters", {
  check_ckan(url)

  pkg_name <- paste0("test_pkg_", as.integer(Sys.time()))

  a <- package_create(name = pkg_name, owner_org = oid, url = url, key = key)

  expect_is(a, "ckan_package")
  expect_is(a$id, "character")
  expect_equal(a$name, pkg_name)
  expect_equal(a$state, "active")

  # Clean up
  package_delete(a$id, url = url, key = key)
})

test_that("package_create creates a package with full parameters", {
  check_ckan(url)

  pkg_name <- paste0("test_pkg_full_", as.integer(Sys.time()))

  a <- package_create(
    name = pkg_name,
    title = "Test Package Full",
    author = "Test Author",
    author_email = "test@example.com",
    maintainer = "Test Maintainer",
    maintainer_email = "maintainer@example.com",
    notes = "This is a test package",
    owner_org = oid,
    tags = list(list(name = "test"), list(name = "example")),
    url = url,
    key = key
  )

  expect_is(a, "ckan_package")
  expect_equal(a$name, pkg_name)
  expect_equal(a$title, "Test Package Full")
  expect_equal(a$author, "Test Author")
  expect_equal(a$author_email, "test@example.com")
  expect_equal(a$maintainer, "Test Maintainer")
  expect_equal(a$maintainer_email, "maintainer@example.com")
  expect_equal(a$notes, "This is a test package")
  expect_equal(length(a$tags), 2)

  # Clean up
  package_delete(a$id, url = url, key = key)
})

test_that("package_create with private flag", {
  check_ckan(url)

  pkg_name <- paste0("test_pkg_private_", as.integer(Sys.time()))

  a <- package_create(
    name = pkg_name,
    private = TRUE,
    owner_org = oid,
    url = url,
    key = key
  )

  expect_is(a, "ckan_package")
  expect_equal(a$private, TRUE)

  # Clean up
  package_delete(a$id, url = url, key = key)
})

test_that("package_create fails well", {
  check_ckan(url)

  # invalid characters in name
  expect_error(
    package_create(name = "Invalid Name With Spaces", owner_org = oid, url = url, key = key),
    "Validation Error"
  )

  # bad key
  expect_error(
    package_create(name = "test_pkg", owner_org = oid, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})

test_that("package_create supports list/json/table formats", {
  check_ckan(url)

  expect_ckan_formats(function(fmt) {
    pkg_name <- paste0("test_pkg_formats_", fmt, "_", as.integer(Sys.time()))
    res <- package_create(name = pkg_name, owner_org = oid, url = url, key = key, as = fmt)
    pkg_id <- switch(fmt,
      json = jsonlite::fromJSON(res)$result$id,
      table = res$id,
      list = res$id
    )
    on.exit(package_delete(pkg_id, url = url, key = key), add = TRUE)
    res
  })
})
