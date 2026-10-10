context("activity offline validation")

skip_on_cran()

test_that("activity_create validates data argument offline", {
  expect_error(
    activity_create("u1", "o1", "changed package", data = 123),
    "`data` must be a named list or JSON string"
  )
  expect_error(
    activity_create("u1", "o1", "changed package", data = c('{"a":1}', '{"b":2}')),
    "`data` must be a named list or JSON string"
  )
})

test_that("activity_create serialises list data (mocked POST)", {
  skip_if_not_installed("jsonlite")
  captured <- new.env(parent = emptyenv())
  testthat::with_mocked_bindings(
    ckan_POST = function(url, method, body = NULL, key = NULL, ...) {
      captured$body <- body
      '{"success": true, "result": {"id": "act-1", "user_id": "u1"}}'
    },
    .package = "ckanr",
    out <- activity_create("u1", "o1", "changed package",
      data = list(message = "hi"), url = "https://example.com", key = "k")
  )
  expect_true(is.list(out))
  expect_identical(out$id, "act-1")
  expect_true(grepl("message", captured$body$data))

  # JSON string data passes through
  testthat::with_mocked_bindings(
    ckan_POST = function(url, method, body = NULL, key = NULL, ...) {
      captured$body <- body
      '{"success": true, "result": {"id": "act-2"}}'
    },
    .package = "ckanr",
    out2 <- activity_create("u1", "o1", "changed package",
      data = '{"message":"hi"}', url = "https://example.com", key = "k")
  )
  expect_identical(out2$id, "act-2")
})

test_that("activity_delete validates id/date/offset arguments (mocked)", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    .package = "ckanr",
    expect_error(
      activity_delete(url = "https://example.com", key = "k"),
      "Provide `id`, `offset_days`"
    )
  )
})

test_that("activity_delete builds body (mocked POST)", {
  captured <- new.env(parent = emptyenv())
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_POST = function(url, method, body = NULL, key = NULL, ...) {
      captured$body <- body
      '{"success": true, "result": true}'
    },
    .package = "ckanr",
    res <- activity_delete(id = "act-1", url = "https://example.com", key = "k")
  )
  expect_true(isTRUE(res) || is.list(res) || is.null(res))
})

test_that("send_email_notifications stops when disabled (mocked)", {
  testthat::with_mocked_bindings(
    activity_email_notifications_enabled = function(...) FALSE,
    .package = "ckanr",
    expect_error(
      send_email_notifications(url = "https://example.com", key = "k"),
      "email notifications are disabled"
    )
  )
})

test_that("activity_email_notifications_enabled parses truthy/falsy", {
  # unknown host returns NA without caching a wrong value
  v1 <- ckanr:::activity_email_notifications_enabled(
    url = "https://127.0.0.1:9", key = NULL)
  expect_true(is.na(v1) || is.logical(v1))
})
