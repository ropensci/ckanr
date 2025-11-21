context("resource_create")

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

test_that("resource_create creates a resource with file upload", {
  check_ckan(url)
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

  res <- resource_create(
    package_id = did,
    description = "Test resource",
    name = "test_resource",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  expect_is(res, "ckan_resource")
  expect_is(res$id, "character")
  expect_equal(res$name, "test_resource")
  expect_equal(res$description, "Test resource")
  expect_equal(res$format, "CSV")

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("resource_create creates a resource with URL only", {
  check_ckan(url)
  check_dataset(url, did)

  res <- resource_create(
    package_id = did,
    description = "URL resource",
    name = "url_resource",
    rcurl = "http://example.com/data.csv",
    format = "CSV",
    url = url,
    key = key
  )

  expect_is(res, "ckan_resource")
  expect_is(res$id, "character")
  expect_equal(res$name, "url_resource")

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("resource_create works with extras", {
  check_ckan(url)
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

  res <- resource_create(
    package_id = did,
    description = "Resource with extras",
    name = "extras_resource",
    upload = path,
    rcurl = "http://example.com",
    extras = list(species = "grizzly", habitat = "forest"),
    url = url,
    key = key
  )

  expect_is(res, "ckan_resource")
  expect_equal(res$species, "grizzly")
  expect_equal(res$habitat, "forest")

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("resource_create accepts ckan_package object", {
  check_ckan(url)

  pkg <- package_show(did, url = url, key = key)
  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

  res <- resource_create(
    package_id = pkg,
    description = "Package object resource",
    name = "pkg_obj_resource",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  expect_is(res, "ckan_resource")
  expect_is(res$id, "character")

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("resource_create fails well", {
  check_ckan(url)

  # missing package_id - this will fail during coercion
  expect_error(
    resource_create(description = "Test", name = "test", rcurl = "http://example.com", url = url, key = key)
  )

  # invalid package_id
  expect_error(
    resource_create(
      package_id = "nonexistent-package",
      description = "Test",
      name = "test",
      rcurl = "http://example.com",
      url = url,
      key = key
    ),
    "Not Found Error"
  )

  # bad key
  expect_error(
    resource_create(
      package_id = did,
      description = "Test",
      name = "test",
      rcurl = "http://example.com",
      url = url,
      key = "invalid-key"
    ),
    "Authorization Error"
  )

  # non-existent file
  expect_error(
    resource_create(
      package_id = did,
      description = "Test",
      name = "test",
      upload = "/nonexistent/file.csv",
      rcurl = "http://example.com",
      url = url,
      key = key
    )
  )
})

test_that("resource_create supports list/json/table formats", {
  check_ckan(url)
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

  expect_ckan_formats(function(fmt) {
    res <- resource_create(
      package_id = did,
      description = "Format resource",
      name = paste0("format_resource_", fmt, "_", as.integer(Sys.time())),
      upload = path,
      rcurl = "http://example.com",
      url = url,
      key = key,
      as = fmt
    )
    rid <- switch(fmt,
      json = jsonlite::fromJSON(res)$result$id,
      table = res$id,
      list = res$id
    )
    on.exit(resource_delete(rid, url = url, key = key), add = TRUE)
    res
  })
})
