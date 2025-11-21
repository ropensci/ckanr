context("dashboard_activity_list")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

skip_if(
  !nzchar(url) || !nzchar(key) || !nzchar(oid),
  "CKAN test settings not configured"
)

unique_dashboard_name <- function(prefix = "ckanr-dashboard") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_dashboard_dataset <- function() {
  pkg_name <- unique_dashboard_name()
  package_create(
    name = pkg_name,
    title = paste("Dashboard dataset", pkg_name),
    owner_org = oid,
    url = url,
    key = key
  )
}

wait_for_activity <- function(fetch_fn, predicate, timeout = 20, interval = 1) {
  deadline <- Sys.time() + timeout
  repeat {
    result <- fetch_fn()
    if (isTRUE(predicate(result))) {
      return(result)
    }
    if (Sys.time() >= deadline) {
      testthat::skip("Activity stream did not update in time")
    }
    Sys.sleep(interval)
  }
}

test_that("dashboard_activity_list captures new dataset activity", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  dashboard_mark_activities_old(url = url, key = key)

  pkg <- create_dashboard_dataset()
  on.exit(
    {
      try(package_delete(pkg$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  activities <- wait_for_activity(
    fetch_fn = function() {
      dashboard_activity_list(limit = 10, url = url, key = key)
    },
    predicate = function(items) {
      is.list(items) && length(items) > 0 &&
        any(vapply(items, function(x) identical(x$object_id, pkg$id), logical(1)))
    }
  )

  expect_is(activities, "list")
  expect_true(any(vapply(activities, function(x) x$object_id == pkg$id, logical(1))))
})

test_that("dashboard_activity_list respects limit and offset", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  pkg <- create_dashboard_dataset()
  on.exit(
    {
      try(package_delete(pkg$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  wait_for_activity(
    fetch_fn = function() dashboard_activity_list(limit = 5, url = url, key = key),
    predicate = function(items) {
      is.list(items) && any(vapply(items, function(x) identical(x$object_id, pkg$id), logical(1)))
    }
  )

  limited <- dashboard_activity_list(limit = 1, url = url, key = key)
  expect_true(length(limited) <= 1)

  offset <- dashboard_activity_list(limit = 1, offset = 1, url = url, key = key)
  if (length(limited) == 1 && length(offset) == 1) {
    expect_false(identical(limited[[1]]$id, offset[[1]]$id))
  }
})

test_that("dashboard_activity_list supports json output", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  pkg <- create_dashboard_dataset()
  on.exit(
    {
      try(package_delete(pkg$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  wait_for_activity(
    fetch_fn = function() dashboard_activity_list(limit = 5, url = url, key = key),
    predicate = function(items) {
      is.list(items) && any(vapply(items, function(x) identical(x$object_id, pkg$id), logical(1)))
    }
  )

  json_txt <- dashboard_activity_list(url = url, key = key, as = "json")
  expect_is(json_txt, "character")
  parsed <- jsonlite::fromJSON(json_txt)
  expect_is(parsed, "list")
  expect_true(length(parsed$result) >= 1)
})

test_that("dashboard_activity_list errors with invalid key", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  expect_error(
    dashboard_activity_list(url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
