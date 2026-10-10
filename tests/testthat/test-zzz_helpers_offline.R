context("zzz helpers offline")

skip_on_cran()

test_that("cc filters NULLs and ck returns action path", {
  expect_identical(ckanr:::cc(list(a = 1, b = NULL, c = 2)), list(a = 1, c = 2))
  expect_identical(ckanr:::ck(), "api/3/action")
})

test_that("as_log converts logicals to CKAN strings", {
  expect_identical(ckanr:::as_log(TRUE), "true")
  expect_identical(ckanr:::as_log(FALSE), "false")
  expect_error(ckanr:::as_log("yes"))
})

test_that("jsl and jsd parse CKAN envelopes", {
  json <- '{"success": true, "result": {"id": "abc", "n": 1}}'
  lst <- ckanr:::jsl(json)
  expect_identical(lst$id, "abc")
  tbl <- ckanr:::jsd(json)
  expect_identical(tbl$id, "abc")
})

test_that("parse_ckan_response handles as variants and errors", {
  json <- '{"success": true, "result": {"id": "abc"}}'
  expect_type(ckanr:::parse_ckan_response(json, as = "json"), "character")
  expect_true(is.list(ckanr:::parse_ckan_response(json, as = "list")))
  expect_error(ckanr:::parse_ckan_response(json, as = "bogus"), "Unsupported `as`")
  # list_coercer is applied
  out <- ckanr:::parse_ckan_response(json, as = "list",
    list_coercer = function(x) ckanr:::as_ck(x, "ckan_file"))
  expect_true(inherits(out, "ckan_file"))
})

test_that("ctj and auth_headers shape", {
  expect_identical(
    ckanr:::ctj(),
    list(`Content-Type` = "application/json")
  )
  h <- ckanr:::auth_headers("my-key")
  expect_identical(h$Authorization, "my-key")
  expect_identical(h$`X-CKAN-API-Key`, "my-key")
})

test_that("notrail strips trailing slashes", {
  expect_identical(ckanr:::notrail("https://example.com///"), "https://example.com")
  expect_identical(ckanr:::notrail("https://example.com"), "https://example.com")
})

test_that("assert checks class when non-NULL", {
  expect_silent(ckanr:::assert(NULL, "list"))
  expect_silent(ckanr:::assert(list(), "list"))
  expect_error(ckanr:::assert("x", "list"), "must be of class")
})

test_that("check_http_method validates", {
  expect_silent(ckanr:::check_http_method("GET", c("GET", "POST")))
  expect_error(ckanr:::check_http_method("PUT", c("GET", "POST")), "'http_method' must be")
})

test_that("haz_names checks named lists", {
  expect_true(ckanr:::haz_names(list()))
  expect_true(ckanr:::haz_names(list(a = 1, b = 2)))
  expect_false(ckanr:::haz_names(list(a = 1, 2)))
  expect_error(ckanr:::haz_names("not-a-list"))
})

test_that("file_fmt and strextract extract extensions", {
  expect_identical(ckanr:::file_fmt("https://example.com/data.csv"), "csv")
  expect_true(is.na(ckanr:::file_fmt("https://example.com/noext")))
  expect_identical(ckanr:::strextract("abc.csv", "\\.[A-Za-z0-9]+$"), ".csv")
})

test_that("tojun serialises with auto_unbox", {
  j <- ckanr:::tojun(list(a = 1), TRUE)
  expect_true(grepl('"a":1', as.character(j)))
})

test_that("check4X errors for missing packages and passes for installed", {
  expect_silent(ckanr:::check4X("jsonlite"))
  expect_error(ckanr:::check4X("definitely-not-a-real-pkg-xyz"), "Please install")
})

test_that("validate_ckan_url rejects bad input", {
  expect_error(ckanr:::validate_ckan_url(""), "empty")
  expect_error(ckanr:::validate_ckan_url(NA_character_), "empty")
  expect_error(ckanr:::validate_ckan_url("ftp://example.com"), "must start with")
  expect_silent(ckanr:::validate_ckan_url("https://demo.ckan.org"))
})

test_that("err_handler passes through 2xx and errors on failures", {
  ok <- new.env(parent = emptyenv())
  ok$status_code <- 200
  expect_silent(ckanr:::err_handler(ok))

  bad_json <- new.env(parent = emptyenv())
  bad_json$status_code <- 404
  bad_json$parse <- function(...) '{"error": {"__type": "Not Found Error", "message": ["nope"]}}'
  expect_error(ckanr:::err_handler(bad_json), "404 - Not Found Error")

  bad_text <- new.env(parent = emptyenv())
  bad_text$status_code <- 500
  bad_text$parse <- function(...) "this is not json"
  bad_text$status_http <- function() list(message = "Internal Error")
  expect_error(ckanr:::err_handler(bad_text), "500")
})

test_that("parse_ckan_http_response accepts JSON and rejects HTML", {
  good <- new.env(parent = emptyenv())
  good$parse <- function(...) '{"success":true,"result":{}}'
  expect_type(ckanr:::parse_ckan_http_response(good), "character")

  bad <- new.env(parent = emptyenv())
  bad$parse <- function(...) "<html>nope</html>"
  bad$status_http <- function() list(message = "Unauthorized")
  expect_error(ckanr:::parse_ckan_http_response(bad), "non-JSON response")
})

test_that("pluck extracts fields", {
  x <- list(list(name = "a"), list(name = "b"))
  expect_identical(ckanr:::pluck(x, "name"), list("a", "b"))
  expect_identical(ckanr:::pluck(x, "name", character(1)), c("a", "b"))
})

test_that("asl maps logical-likes", {
  expect_identical(ckanr:::asl(TRUE), "true")
  expect_identical(ckanr:::asl(FALSE), "false")
  expect_identical(ckanr:::asl("true"), "true")
  expect_identical(ckanr:::asl("other"), "other")
})

test_that("ensure_action_available fails clearly when offline", {
  expect_error(
    ckanr:::ensure_action_available("definitely_missing_action_xyz",
      url = "https://127.0.0.1:9", key = NULL),
    "unavailable on this CKAN instance"
  )
})
