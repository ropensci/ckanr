context("group_create")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })

test_that("group_create creates a group", {
  check_ckan(url)

  grp_name <- paste0("test_group_", as.integer(Sys.time()))

  grp <- group_create(
    name = grp_name,
    title = "Test Group",
    url = url,
    key = key
  )

  expect_is(grp, "ckan_group")
  expect_is(grp$id, "character")
  expect_equal(grp$name, grp_name)
  expect_equal(grp$title, "Test Group")

  # Clean up
  group_delete(grp$id, url = url, key = key)
})

test_that("group_create with full parameters", {
  check_ckan(url)

  grp_name <- paste0("test_group_full_", as.integer(Sys.time()))

  grp <- group_create(
    name = grp_name,
    title = "Full Test Group",
    description = "This is a test group",
    image_url = "http://example.com/image.png",
    url = url,
    key = key
  )

  expect_is(grp, "ckan_group")
  expect_equal(grp$name, grp_name)
  expect_equal(grp$title, "Full Test Group")
  expect_equal(grp$description, "This is a test group")

  # Clean up
  group_delete(grp$id, url = url, key = key)
})

test_that("group_create fails well", {
  check_ckan(url)

  # no name provided
  expect_error(group_create(url = url, key = key))

  # invalid characters in name
  expect_error(
    group_create(name = "Invalid Name With Spaces", url = url, key = key),
    "Validation Error"
  )

  # bad key
  expect_error(
    group_create(name = "test_group", url = url, key = "invalid-key"),
    "Authorization Error"
  )
})

test_that("group_create returns json when requested", {
  check_ckan(url)

  grp_name <- paste0("test_group_json_", as.integer(Sys.time()))

  grp <- group_create(
    name = grp_name,
    title = "JSON Group",
    url = url,
    key = key,
    as = "json"
  )

  expect_is(grp, "character")
  grp_parsed <- jsonlite::fromJSON(grp)
  expect_is(grp_parsed, "list")

  # Clean up
  group_delete(grp_parsed$result$id, url = url, key = key)
})
