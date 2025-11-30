context("user_lifecycle")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

skip_if_not_sysadmin(url, key)

unique_user_name <- function(prefix = "ckanr-user") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sprintf("%04d", sample(10000, 1)), sep = "-")
}

create_temp_user <- function(name = unique_user_name()) {
  user_create(
    name = name,
    email = sprintf("%s@example.com", name),
    password = sprintf("pass-%06d", sample(1e6, 1)),
    fullname = sprintf("CKANR Test %s", name),
    about = "temporary user for lifecycle tests",
    url = url,
    key = key
  )
}

cleanup_user <- function(id) {
  suppressWarnings(try(user_delete(id, url = url, key = key), silent = TRUE))
}

with_follower_actions <- function(code) {
  code <- substitute(code)
  follow_actions <- c(
    "follow_user",
    "unfollow_user",
    "am_following_user",
    "user_follower_count",
    "user_follower_list",
    "user_followee_count",
    "user_followee_list"
  )
  available <- vapply(
    follow_actions,
    ckanr:::ckan_action_available,
    logical(1),
    url = url,
    key = key
  )
  if (!all(available)) {
    skip("User follower endpoints unavailable on this CKAN instance")
  }
  eval(code, parent.frame())
}

test_that("user_create and user_delete roundtrip", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  expect_is(usr, "ckan_user")
  expect_true(nzchar(usr$id))
  expect_equal(usr$name, tolower(usr$name))

  listed <- user_list(q = usr$name, url = url, key = key)
  expect_true(any(vapply(listed, `[[`, character(1), "name") == usr$name))

  deleted <- user_delete(usr$id, url = url, key = key)
  expect_true(isTRUE(deleted))

  deleted_user <- user_show(usr$name, url = url, key = key)
  expect_equal(deleted_user$state, "deleted")
})

test_that("user_activity_list handles fresh users", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  if (!ckanr:::ckan_action_available("user_activity_list", url = url, key = key)) {
    skip("user_activity_list action unavailable on this CKAN instance")
  }

  activities <- user_activity_list(usr$id, limit = 5, url = url, key = key)
  expect_true(is.list(activities))
  expect_gte(length(activities), 0)
})

test_that("user_create and user_delete fail well", {
  check_ckan(url)

  expect_error(
    user_create(email = "tester@example.com", password = "pass", url = url, key = key),
    'argument "name" is missing'
  )

  expect_error(
    user_create(name = "abc123", password = "pass", url = url, key = key),
    'argument "email" is missing'
  )

  expect_error(
    user_delete("nonexistent-user-name", url = url, key = key),
    "Not Found Error"
  )

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  expect_error(
    user_delete(usr$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})

test_that("user follower helpers reflect follow/unfollow state", {
  check_ckan(url)
  with_follower_actions({
    follower <- tryCatch(current_test_user(url, key), error = function(e) e)
    if (inherits(follower, "error")) {
      skip("Unable to determine current user")
    }

    usr <- create_temp_user()
    on.exit(
      {
        suppressWarnings(try(unfollow_user(usr$id, url = url, key = key), silent = TRUE))
        cleanup_user(usr$id)
      },
      add = TRUE
    )

    baseline_followers <- user_follower_count(usr$id, url = url, key = key)
    expect_true(is.numeric(baseline_followers))
    expect_equal(as.integer(baseline_followers), 0L)

    baseline_list <- user_follower_list(usr$id, url = url, key = key)
    expect_true(is.list(baseline_list))
    expect_equal(length(baseline_list), 0)

    follow_user(usr$id, url = url, key = key)
    expect_true(isTRUE(am_following_user(usr$id, url = url, key = key)))

    follower_count <- user_follower_count(usr$id, url = url, key = key)
    expect_equal(as.integer(follower_count), 1L)

    follower_list <- user_follower_list(usr$id, url = url, key = key)
    expect_true(length(follower_list) >= 1)
    follower_matches <- vapply(
      follower_list,
      function(entry) {
        vals <- as.character(unlist(entry, use.names = FALSE))
        follower$name %in% vals || follower$id %in% vals
      },
      logical(1)
    )
    expect_true(any(follower_matches))

    followee_list <- user_followee_list(follower$name, url = url, key = key)
    followee_matches <- vapply(
      followee_list,
      function(entry) {
        vals <- as.character(unlist(entry, use.names = FALSE))
        usr$name %in% vals || usr$id %in% vals
      },
      logical(1)
    )
    expect_true(any(followee_matches))

    unfollow_user(usr$id, url = url, key = key)
    expect_false(isTRUE(am_following_user(usr$id, url = url, key = key)))
  })
})
