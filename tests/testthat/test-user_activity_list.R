context("user_activity_list")

skip_on_cran()

url <- get_test_url()
has_user_activity <- local({
  actions <- tryCatch(
    jsonlite::fromJSON(
      ckan_action("action_list", verb = "GET", url = url)
    )$result,
    error = function(e) NULL
  )
  isTRUE("user_activity_list" %in% actions)
})

test_that("user_activity_list returns activities", {
  check_ckan(url)
  skip_if_not(has_user_activity, "user_activity_list action unavailable on this CKAN instance")

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
  skip_if_not(has_user_activity, "user_activity_list action unavailable on this CKAN instance")

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
  skip_if_not(has_user_activity, "user_activity_list action unavailable on this CKAN instance")

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
  skip_if_not(has_user_activity, "user_activity_list action unavailable on this CKAN instance")

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
  skip_if_not(has_user_activity, "user_activity_list action unavailable on this CKAN instance")

  # non-existent user
  expect_error(
    user_activity_list("nonexistent-user-xyz123", url = url),
    "Not Found Error"
  )
})
