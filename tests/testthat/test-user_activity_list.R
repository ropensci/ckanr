context("user_activity_list")

skip_on_cran()

url <- get_test_url()

test_that("user_activity_list returns activities", {
  check_ckan(url)

  # Get a user from user_list
  users <- user_list(url = url)
  if (length(users) > 0) {
    user_id <- users[[1]]$name

    res <- user_activity_list(user_id, url = url)

    expect_is(res, "list")
  } else {
    skip("No users available for testing")
  }
})

test_that("user_activity_list respects limit parameter", {
  check_ckan(url)

  users <- user_list(url = url)
  if (length(users) > 0) {
    user_id <- users[[1]]$name

    res <- user_activity_list(user_id, limit = 5, url = url)

    expect_is(res, "list")
    expect_lte(length(res), 5)
  } else {
    skip("No users available for testing")
  }
})

test_that("user_activity_list accepts ckan_user object", {
  check_ckan(url)

  users <- user_list(url = url)
  if (length(users) > 0) {
    user_id <- users[[1]]$name
    user_obj <- user_show(user_id, url = url)

    res <- user_activity_list(user_obj, url = url)

    expect_is(res, "list")
  } else {
    skip("No users available for testing")
  }
})

test_that("user_activity_list works with different output formats", {
  check_ckan(url)

  users <- user_list(url = url)
  if (length(users) > 0) {
    user_id <- users[[1]]$name

    # JSON output
    res_json <- user_activity_list(user_id, url = url, as = "json")
    expect_is(res_json, "character")

    # Table output
    res_table <- user_activity_list(user_id, url = url, as = "table")
    expect_true(is.data.frame(res_table) || is.list(res_table))
  } else {
    skip("No users available for testing")
  }
})

test_that("user_activity_list fails well", {
  check_ckan(url)

  # non-existent user
  expect_error(
    user_activity_list("nonexistent-user-xyz123", url = url),
    "Not Found Error"
  )
})
