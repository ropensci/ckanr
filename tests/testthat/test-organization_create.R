context("organization_create")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

test_that("The CKAN URL must be set", {
  expect_is(url, "character")
})
test_that("The CKAN API key must be set", {
  expect_is(key, "character")
})

test_that("organization_create creates an organization", {
  check_ckan(url)

  org_name <- paste0("test_org_", as.integer(Sys.time()))

  org <- organization_create(
    name = org_name,
    title = "Test Organization",
    url = url,
    key = key
  )

  expect_is(org, "ckan_organization")
  expect_is(org$id, "character")
  expect_equal(org$name, org_name)
  expect_equal(org$title, "Test Organization")

  # Clean up
  organization_delete(org$id, url = url, key = key)
})

test_that("organization_create with full parameters", {
  check_ckan(url)

  org_name <- paste0("test_org_full_", as.integer(Sys.time()))

  org <- organization_create(
    name = org_name,
    title = "Full Test Organization",
    description = "This is a test organization",
    image_url = "http://example.com/image.png",
    url = url,
    key = key
  )

  expect_is(org, "ckan_organization")
  expect_equal(org$name, org_name)
  expect_equal(org$title, "Full Test Organization")
  expect_equal(org$description, "This is a test organization")

  # Clean up
  organization_delete(org$id, url = url, key = key)
})

test_that("organization_create fails well", {
  check_ckan(url)

  # no name provided
  expect_error(organization_create(url = url, key = key))

  # invalid characters in name
  expect_error(
    organization_create(name = "Invalid Name With Spaces", url = url, key = key),
    "Validation Error"
  )

  # bad key
  expect_error(
    organization_create(name = "test_org", url = url, key = "invalid-key"),
    "Authorization Error"
  )
})

test_that("organization_create supports list/json/table formats", {
  check_ckan(url)

  expect_ckan_formats(function(fmt) {
    org_name <- paste0("test_org_formats_", fmt, "_", as.integer(Sys.time()))
    res <- organization_create(
      name = org_name,
      title = "Format Organization",
      url = url,
      key = key,
      as = fmt
    )
    org_id <- switch(fmt,
      json = jsonlite::fromJSON(res)$result$id,
      table = res$id,
      list = res$id
    )
    on.exit(organization_delete(org_id, url = url, key = key), add = TRUE)
    res
  })
})
