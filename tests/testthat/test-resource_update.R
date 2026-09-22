context("resource_update")

skip_on_cran()

# to avoid failures, probably due to this same event
# being attempted at the same-ish time on different CI operating systems
# just run on linux
skip_on_os("windows")
skip_on_os("mac")

# Use a local example file from package ckanR
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

# Set CKAN connection from ckanr_settings
url <- get_test_url()
key <- get_test_key()
did <- get_test_did()
tt <- tryCatch(package_show(did, key = key, url = url), error = function(e) e)
if (inherits(tt, "error")) {
  did <- package_create(did, url = url, key = key)$id
}
# rid <- get_test_rid()
rid <- resource_create(
  package_id = did,
  description = "my resource",
  name = "bears",
  upload = path,
  rcurl = "http://google.com",
  url = url, key = key
)
rid <- rid$id

test_that("The CKAN URL must be set", {
  expect_is(url, "character")
})
test_that("The CKAN API key must be set", {
  expect_is(key, "character")
})
test_that("A CKAN resource ID must be set", {
  expect_is(rid, "character")
})

# Test update_resource
test_that("resource_update gives back expected class types and output", {
  check_ckan(url)
  check_resource(url, rid)

  # xx <- resource_create(package_id = did,
  #                       description = "my resource",
  #                       name = "bears",
  #                       upload = path,
  #                       rcurl = "http://google.com",
  #                       url = url, key = key)
  a <- resource_update(rid, path = path, url = url, key = key)

  # class types
  # expect_is(a, "ckan_resource")
  expect_is(a, "ckan_resource")
  expect_is(a$id, "character")

  # expected output
  expect_equal(a$id, rid)
  expect_equal(a$format, "CSV")
  expect_ckan_formats(function(fmt) {
    resource_update(rid, path = path, url = url, key = key, as = fmt)
  })
})

# html
test_that("resource_update gives back expected class types and output with html", {
  check_ckan(url)
  check_resource(url, rid)

  path <- system.file("examples", "mapbox.html", package = "ckanr")
  xx <- resource_create(
    package_id = did, description = "a map, yay",
    name = "mapyay", upload = path,
    rcurl = "http://google.com", url = url, key = key
  )
  dat <- readLines(path)
  dat <- sub("-111.06", "-115.06", dat)
  newpath <- tempfile(fileext = ".html")
  cat(dat, file = newpath, sep = "\n")
  a <- resource_update(xx, path = newpath, url = url, key = key)

  # class types
  expect_is(a, "ckan_resource")
  expect_is(a$id, "character")

  # expected output
  expect_equal(a$id, xx$id)
  expect_equal(a$format, "HTML")
})

test_that("resource_update fails well", {
  check_ckan(url)
  check_resource(url, rid)

  # all parameters missing
  expect_error(resource_update(), "argument \"id\" is missing, with no default")

  # bad resource id
  expect_error(
    resource_update("invalid-resource-id", path = path, url = url, key = key),
    "Not Found Error"
  )

  # bad file path: local file does not exist
  expect_error(resource_update(rid, "invalid-file-path", url = url, key = key))

  # bad url
  expect_error(resource_update(rid, path = path, url = "invalid-URL", key = key))

  # bad key
  expect_error(
    resource_update(rid, path = path, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})

# extras on resource_create
test_that("resource_create gives back expected key:value pairs", {
  check_ckan(url)
  check_resource(url, rid)

  path <- system.file("examples", "mapbox.html", package = "ckanr")
  xx <- resource_create(
    package_id = did, description = "a map, yay",
    name = "mapyay", upload = path,
    extras = list(map_type = "mapbox"),
    rcurl = "http://google.com", url = url, key = key
  )

  # expected output
  expect_equal(xx$map_type, "mapbox")
})

# extras on resource_update
test_that("resource_update gives back expected key:value pairs", {
  check_ckan(url)
  check_resource(url, rid)

  a <- resource_update(rid,
    path = path, extras = list(map_type = "mapbox"),
    url = url, key = key
  )

  # expected output
  expect_equal(a$map_type, "mapbox")
})

# extras on resource_update without path
test_that("resource_update gives back expected key:value pairs even without path", {
  check_ckan(url)
  check_resource(url, rid)

  a <- resource_update(rid,
    extras = list(map_type = "mapbox"),
    url = url, key = key
  )

  # expected output
  expect_equal(a$map_type, "mapbox")
})

# extras removed on resource_update with empty extras
test_that("resource_update removes key:value pairs with empty extras", {
  check_ckan(url)
  check_resource(url, rid)

  a <- resource_update(rid,
    extras = list(map_type = "mapbox"),
    url = url, key = key
  )

  b <- resource_update(rid,
    extras = list(),
    url = url, key = key
  )

  # expected output
  testthat::expect_null(b$map_type)
})

# rcurl on resource_update points the resource at a new external URL
test_that("resource_update changes the external URL through rcurl", {
  check_ckan(url)
  check_dataset(url, did)

  xx <- resource_create(
    package_id = did, description = "rcurl update test",
    name = "rcurl-update-test", upload = path,
    rcurl = "http://example.com", url = url, key = key
  )
  on.exit(
    {
      try(resource_delete(xx$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  new_url <- "https://example.com/arcgis/item.html?id=abc123"
  a <- resource_update(xx$id, rcurl = new_url, url = url, key = key)

  expect_is(a, "ckan_resource")
  expect_equal(a$url, new_url)
  expect_equal(a$url_type, "link")

  shown <- resource_show(xx$id, url = url, key = key)
  expect_equal(shown$url, new_url)

  # S3 input: a ckan_resource object works like an ID string
  b <- resource_update(a, rcurl = "https://example.com/other", url = url, key = key)
  expect_equal(b$url, "https://example.com/other")

  # Output formats
  expect_ckan_formats(function(fmt) {
    resource_update(xx$id,
      rcurl = "https://example.com/fmt", url = url, key = key, as = fmt)
  })
})

# an uploaded file wins over rcurl on resource_update
test_that("resource_update prefers an uploaded file over rcurl", {
  check_ckan(url)
  check_dataset(url, did)

  xx <- resource_create(
    package_id = did, description = "rcurl upload test",
    name = "rcurl-upload-test", upload = path,
    rcurl = "http://example.com", url = url, key = key
  )
  on.exit(
    {
      try(resource_delete(xx$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  a <- resource_update(xx$id,
    path = path, rcurl = "https://example.com/ignored",
    url = url, key = key
  )

  expect_equal(a$url_type, "upload")
  expect_match(a$url, "actinidiaceae.csv$", fixed = FALSE)
})
