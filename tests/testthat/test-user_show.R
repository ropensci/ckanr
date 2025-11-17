context("user_show")

skip_on_cran()

u <- get_test_url()

test_that("user_show gives back expected class types", {
  check_ckan(u)

  # Get a user from user_list
  users <- user_list(url = u)
  if (length(users) > 0) {
    user_id <- users[[1]]$name
    a <- user_show(user_id, url = u)

    expect_is(a, "ckan_user")
    expect_is(a$id, "character")
    expect_is(a$name, "character")
  } else {
    skip("No users available for testing")
  }
})

test_that("user_show works with include_datasets parameter", {
  check_ckan(u)

  users <- user_list(url = u)
  if (length(users) > 0) {
    user_id <- users[[1]]$name
    a <- user_show(user_id, include_datasets = TRUE, url = u)

    expect_is(a, "ckan_user")
    expect_true("datasets" %in% names(a) || "number_created_packages" %in% names(a))
  } else {
    skip("No users available for testing")
  }
})

test_that("user_show works with include_num_followers parameter", {
  check_ckan(u)

  users <- user_list(url = u)
  if (length(users) > 0) {
    user_id <- users[[1]]$name
    a <- user_show(user_id, include_num_followers = TRUE, url = u)

    expect_is(a, "ckan_user")
    expect_true("num_followers" %in% names(a) || "number_of_followers" %in% names(a))
  } else {
    skip("No users available for testing")
  }
})

test_that("user_show works giving back json output", {
  check_ckan(u)

  users <- user_list(url = u)
  if (length(users) > 0) {
    user_id <- users[[1]]$name
    b <- user_show(user_id, url = u, as = "json")
    b_df <- jsonlite::fromJSON(b)

    expect_is(b, "character")
    expect_is(b_df, "list")
  } else {
    skip("No users available for testing")
  }
})

test_that("user_show fails well", {
  check_ckan(u)

  # non-existent user
  expect_error(user_show("nonexistent-user-xyz123", url = u), "Not Found Error")
})
