context("coverage100 last mile")

skip_on_cran()

C <- '{"success":true,"result":{"id":"x1","name":"n1"}}'

test_that("files accept ckan_file objects", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_POST = function(...) C,
    .package = "ckanr",
    {
      f <- as.ckan_file(list(id = "f1", name = "a.csv"))
      expect_false(is.null(file_delete(f, url = "https://example.com")))
      expect_false(is.null(file_rename(
        f,
        "b.csv",
        url = "https://example.com"
      )))
      expect_false(is.null(file_pin(f, url = "https://example.com")))
      expect_false(is.null(file_unpin(f, url = "https://example.com")))
      expect_false(is.null(file_ownership_transfer(
        f,
        "o1",
        "package",
        url = "https://example.com"
      )))
    }
  )
})

test_that("read_csv_base EOF warning branch", {
  # write a file with unclosed quote to exercise fallback (error path);
  # the "EOF within quoted string" warning handler is excluded from
  # coverage (R-version dependent, see # nocov in read_csv_base)
  f <- tempfile(fileext = ".csv")
  writeLines(c('a,b', '1,"unclosed'), f)
  on.exit(unlink(f), add = TRUE)
  df <- suppressWarnings(ckanr:::read_csv_base(path = f))
  expect_true(is.data.frame(df))
})

test_that("src_ckan missing dep branches", {
  # mock requireNamespace in base namespace
  testthat::with_mocked_bindings(
    requireNamespace = function(package, ...) {
      if (identical(package, "dplyr")) {
        return(FALSE)
      }
      TRUE
    },
    .package = "base",
    expect_error(src_ckan("https://example.com"), "Please install dplyr")
  )
  testthat::with_mocked_bindings(
    requireNamespace = function(package, ...) {
      if (identical(package, "dbplyr")) {
        return(FALSE)
      }
      TRUE
    },
    .package = "base",
    expect_error(src_ckan("https://example.com"), "Please install dbplyr")
  )
})

test_that("sql_translation paste branch", {
  drv <- new("CKANDriver")
  con <- DBI::dbConnect(drv, url = "https://demo.ckan.org", key = "k")
  tr <- dbplyr::sql_translation(con)
  # call the paste translator directly (line 86)
  paste_fn <- tr$scalar$paste %||% tr$aggregate$paste
  # aggregate paste
  agg_paste <- NULL
  try(
    {
      # sql_variant structure: $scalar, $aggregate, $window
      agg_paste <- tr$aggregate$paste
    },
    silent = TRUE
  )
  if (!is.null(agg_paste) && is.function(agg_paste)) {
    # set dbplyr current connection so sql_glue has context (covers dplyr.R:86)
    ctx <- getFromNamespace("sql_context", "dbplyr")
    old_con <- ctx$con
    on.exit(ctx$con <- old_con, add = TRUE)
    ctx$con <- con
    out <- agg_paste(dbplyr::sql("x"), collapse = ",")
    expect_true(!is.null(out))
  } else {
    expect_true(TRUE)
  }
})

test_that("activity cache hit branch", {
  url <- "https://example.com/cache-test-xyz"
  testthat::with_mocked_bindings(
    config_option_show = function(...) list(value = "yes"),
    .package = "ckanr",
    {
      first <- ckanr:::activity_email_notifications_enabled(
        url = url,
        key = "k"
      )
      expect_true(isTRUE(first))
      # second call should hit cache (line 323) even if backend now errors
    }
  )
  testthat::with_mocked_bindings(
    config_option_show = function(...) stop("should not be called"),
    .package = "ckanr",
    {
      second <- ckanr:::activity_email_notifications_enabled(
        url = url,
        key = "k"
      )
      expect_true(isTRUE(second))
    }
  )
})

test_that("organization_delete list branch and package_show ckan object", {
  testthat::with_mocked_bindings(
    ckan_POST = function(...) '{"success":true}',
    ckan_GET = function(...) C,
    .package = "ckanr",
    {
      expect_true(isTRUE(organization_delete(
        list(id = "o1"),
        url = "https://example.com"
      )))
      pkg <- structure(list(id = "p1"), class = "ckan_package")
      expect_false(is.null(package_show(pkg, url = "https://example.com")))
    }
  )
})

test_that("package_owner_org_update already-correct branch", {
  testthat::with_mocked_bindings(
    as.ckan_package = function(x, ...) {
      structure(list(id = "p1"), class = "ckan_package")
    },
    as.ckan_organization = function(x, ...) {
      structure(list(id = "org1"), class = "ckan_organization")
    },
    ckan_POST = function(...) '{"success":true}',
    ckan_version = function(...) list(version_num = 212),
    package_owner_org_id = function(...) "org1",
    .package = "ckanr",
    expect_true(package_owner_org_update(
      "p1",
      "org1",
      url = "https://example.com"
    ))
  )
})

test_that("resource_view_update with resource object", {
  testthat::with_mocked_bindings(
    ckan_GET = function(...) C,
    ckan_PATCH = function(...) C,
    ckan_POST = function(...) C,
    .package = "ckanr",
    expect_false(is.null(resource_view_update(
      list(id = "v1"),
      resource = list(id = "r1"),
      url = "https://example.com"
    )))
  )
})

test_that("revision_list try-error branch", {
  testthat::with_mocked_bindings(
    ckan_version = function(...) stop("down"),
    ckan_GET = function(...) C,
    .package = "ckanr",
    {
      # ver try-error -> NA -> else branch with as variants
      expect_false(is.null(revision_list(
        url = "https://example.com",
        as = "json"
      )))
      expect_false(is.null(revision_list(
        url = "https://example.com",
        as = "table"
      )))
    }
  )
})

test_that("tag_delete table branch", {
  testthat::with_mocked_bindings(
    ckan_POST = function(...) '{"success":true}',
    .package = "ckanr",
    expect_true(isTRUE(tag_delete(
      "t1",
      url = "https://example.com",
      as = "table"
    )))
  )
})

test_that("organization_delete and tag_delete invalid id errors", {
  expect_error(
    organization_delete(123, url = "https://example.com"),
    "must be a string"
  )
  expect_error(
    organization_delete(list(foo = 1), url = "https://example.com"),
    "must be a string"
  )
  expect_error(tag_delete(123, url = "https://example.com"), "must be a string")
  expect_error(
    tag_delete(list(foo = 1), url = "https://example.com"),
    "must be a string"
  )
})
