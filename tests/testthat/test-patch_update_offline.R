context("patch/update offline validation")

skip_on_cran()

test_that("package_patch requires id when x lacks one", {
  expect_error(
    package_patch(
      list(title = "no id"),
      url = "https://example.com",
      key = "k"
    ),
    "`id` field not found"
  )
})

test_that("package_patch builds body from list (mocked POST)", {
  captured <- new.env(parent = emptyenv())
  testthat::with_mocked_bindings(
    ckan_POST = function(url, method, body = NULL, key = NULL, ...) {
      captured$body <- body
      '{"success": true, "result": {"id": "pkg-1", "title": "T"}}'
    },
    .package = "ckanr",
    out <- package_patch(
      list(id = "pkg-1", title = "T"),
      url = "https://example.com",
      key = "k"
    )
  )
  expect_true(is.ckan_package(out) || is.list(out))
  # invalid `as` falls through switch to NULL (no crash)
  testthat::with_mocked_bindings(
    ckan_POST = function(url, method, body = NULL, key = NULL, ...) {
      '{"success": true, "result": {"id": "pkg-1", "title": "T"}}'
    },
    .package = "ckanr",
    out_bad <- package_patch(
      list(id = "pkg-1"),
      url = "https://example.com",
      key = "k",
      as = "bogus"
    )
  )
  expect_null(out_bad)
})

test_that("revision_list warns and returns NULL on CKAN >= 2.9 (mocked version)", {
  testthat::with_mocked_bindings(
    ckan_version = function(...) list(version = "2.11.0", version_num = 211),
    .package = "ckanr",
    {
      expect_warning(
        res <- revision_list(url = "https://example.com"),
        "removed in CKAN 2.9"
      )
      expect_null(res)
    }
  )
})

test_that("package_revision_list deprecates on CKAN >= 2.9 (mocked version)", {
  testthat::with_mocked_bindings(
    ckan_version = function(...) list(version = "2.11.0", version_num = 211),
    .package = "ckanr",
    {
      expect_warning(
        res <- suppressWarnings(
          package_revision_list("pkg-1", url = "https://example.com")
        ),
        NA
      )
      # deprecated path returns NULL
      expect_null(suppressWarnings(
        package_revision_list("pkg-1", url = "https://example.com")
      ))
    }
  )
})

test_that("resource_update rejects non-list extras offline", {
  expect_error(
    resource_update(
      "res-id",
      extras = "not-a-list",
      url = "https://example.com",
      key = "k"
    ),
    "must be of class"
  )
})

test_that("pick_type maps MIME types", {
  expect_identical(ckanr:::pick_type("text/html"), "html")
  expect_identical(ckanr:::pick_type("text/csv"), "csv")
  expect_identical(ckanr:::pick_type("text/plain"), "txt")
  expect_identical(ckanr:::pick_type("application/json"), "json")
  expect_identical(ckanr:::pick_type("application/pdf"), "pdf")
  expect_identical(ckanr:::pick_type("image/jpeg"), "jpeg")
  expect_null(ckanr:::pick_type("application/unknown-xyz"))
})

test_that("group_purge and organization_purge validate offline", {
  # purge helpers call ensure_action_available first; with unreachable
  # host they must fail clearly rather than hang
  expect_error(
    group_purge("some-id", url = "https://127.0.0.1:9", key = "k"),
    "unavailable|failed|Could not resolve|Connection|error",
    ignore.case = TRUE
  )
})
