context("group_delete")

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

test_that("group_delete deletes a group", {
  check_ckan(url)

  # Create a group to delete
  grp_name <- paste0("test_group_delete_", as.integer(Sys.time()))
  grp <- group_create(name = grp_name, url = url, key = key)

  # Delete it
  result <- group_delete(grp$id, url = url, key = key)

  expect_true(result)

  # Verify it's marked as deleted
  deleted_grp <- group_show(grp$id, url = url, key = key)
  expect_equal(deleted_grp$state, "deleted")
})

test_that("group_delete accepts ckan_group object", {
  check_ckan(url)

  # Create a group to delete
  grp_name <- paste0("test_group_delete2_", as.integer(Sys.time()))
  grp <- group_create(name = grp_name, url = url, key = key)

  # Delete using the ckan_group object directly
  result <- group_delete(grp, url = url, key = key)

  expect_true(result)
})

test_that("group_delete fails well", {
  check_ckan(url)

  # missing id
  expect_error(
    group_delete(url = url, key = key),
    "argument \"id\" is missing, with no default"
  )

  # invalid id
  expect_error(
    group_delete("nonexistent-group-id", url = url, key = key),
    "Not Found Error"
  )

  # bad key (use a real group id)
  grp_name <- paste0("test_group_delete_badkey_", as.integer(Sys.time()))
  grp <- group_create(name = grp_name, url = url, key = key)
  expect_error(
    group_delete(grp$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
  group_delete(grp$id, url = url, key = key)
})
