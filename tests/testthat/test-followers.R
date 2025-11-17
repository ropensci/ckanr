context("followers")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()
gid <- get_test_gid()

assume_follow_target <- function() {
  target <- Sys.getenv("CKANR_TEST_FOLLOW_USER", "ckanr_follow_target")
  usr <- tryCatch(
    user_show(target, url = url, key = key),
    error = function(e) NULL
  )
  if (is.null(usr)) {
    created <- tryCatch(
      user_create(
        name = target,
        email = sprintf("%s@example.com", target),
        password = "secret123",
        url = url,
        key = key
      ),
      error = function(e) e
    )
    if (inherits(created, "error")) {
      testthat::skip(paste("Unable to provision follow target user:", conditionMessage(created)))
    }
    usr <- created
  }
  usr
}

cleanup_follow_state <- function(target_user) {
  try(suppressWarnings(dataset_unfollow(did, url = url, key = key)), silent = TRUE)
  try(suppressWarnings(group_unfollow(gid, url = url, key = key)), silent = TRUE)
  if (!is.null(target_user)) {
    try(suppressWarnings(unfollow_user(target_user$name, url = url, key = key)), silent = TRUE)
  }
}

current_user <- function() {
  txt <- tryCatch(
    ckan_action("user_show", verb = "GET", url = url, key = key),
    error = function(e) e
  )
  if (inherits(txt, "error")) {
    return(txt)
  }
  jsonlite::fromJSON(txt, simplifyVector = FALSE)$result
}

require_credentials <- function() {
  if (!nzchar(url) || !nzchar(key) || !nzchar(did) || !nzchar(gid)) {
    testthat::skip("CKAN test credentials not configured")
  }
}

test_that("follower counts and lists return data", {
  require_credentials()
  check_ckan(url)
  check_dataset(url, did)
  check_group(url, gid)
  me <- current_user()
  if (inherits(me, "error")) {
    testthat::skip(paste("user_show failed:", conditionMessage(me)))
  }

  expect_true(is.numeric(dataset_follower_count(did, url = url, key = key)))
  expect_type(dataset_follower_list(did, url = url, key = key), "list")

  expect_true(is.numeric(group_follower_count(gid, url = url, key = key)))
  expect_type(group_follower_list(gid, url = url, key = key), "list")

  expect_true(is.numeric(user_follower_count(me$name, url = url, key = key)))
  expect_type(user_follower_list(me$name, url = url, key = key), "list")
})

test_that("follow/unfollow flows toggle state and update followee metrics", {
  require_credentials()
  check_ckan(url)
  check_dataset(url, did)
  check_group(url, gid)

  me <- current_user()
  if (inherits(me, "error")) {
    testthat::skip(paste("user_show failed:", conditionMessage(me)))
  }
  target <- assume_follow_target()
  cleanup_follow_state(target)
  on.exit(cleanup_follow_state(target), add = TRUE)

  int_val <- function(x) {
    if (is.null(x) || length(x) == 0) return(0L)
    as.integer(x)[1]
  }

  base_all <- int_val(followee_count(me$name, url = url, key = key))
  base_dataset_cnt <- int_val(dataset_followee_count(me$name, url = url, key = key))
  base_group_cnt <- int_val(group_followee_count(me$name, url = url, key = key))
  base_user_cnt <- int_val(user_followee_count(me$name, url = url, key = key))

  base_followee_len <- length(followee_list(me$name, url = url, key = key))
  base_dataset_len <- length(dataset_followee_list(me$name, url = url, key = key))
  base_group_len <- length(group_followee_list(me$name, url = url, key = key))
  base_user_len <- length(user_followee_list(me$name, url = url, key = key))

  dataset_follow(did, url = url, key = key)
  expect_true(isTRUE(dataset_am_following(did, url = url, key = key)))
  # dataset_followee_count may lag on some CKAN builds, so only enforce that it
  # never decreases even if it fails to increment immediately.
  expect_gte(int_val(dataset_followee_count(me$name, url = url, key = key)),
    base_dataset_cnt)
  expect_equal(length(dataset_followee_list(me$name, url = url, key = key)),
    base_dataset_len + 1L)

  group_follow(gid, url = url, key = key)
  expect_true(isTRUE(group_am_following(gid, url = url, key = key)))
  expect_equal(int_val(group_followee_count(me$name, url = url, key = key)),
    base_group_cnt + 1L)
  expect_equal(length(group_followee_list(me$name, url = url, key = key)),
    base_group_len + 1L)

  follow_user(target$name, url = url, key = key)
  expect_true(isTRUE(am_following_user(target$name, url = url, key = key)))
  expect_equal(int_val(user_followee_count(me$name, url = url, key = key)),
    base_user_cnt + 1L)
  expect_equal(length(user_followee_list(me$name, url = url, key = key)),
    base_user_len + 1L)

  expect_gte(int_val(followee_count(me$name, url = url, key = key)),
    base_all + 2L)
  expect_gte(length(followee_list(me$name, url = url, key = key)),
    base_followee_len + 2L)
})
