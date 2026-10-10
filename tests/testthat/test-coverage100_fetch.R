context("coverage100 fetch/verb")

skip_on_cran()

test_that("ckan_fetch zip and disk branches", {
  # zip branch: mock fetch_GET to return two csv paths
  f1 <- tempfile(fileext = ".csv")
  f2 <- tempfile(fileext = ".csv")
  writeLines(c("a,b", "1,2"), f1)
  writeLines(c("x,y", "3,4"), f2)
  on.exit(unlink(c(f1, f2)), add = TRUE)
  testthat::with_mocked_bindings(
    fetch_GET = function(...) list(fmt = "zip", data = NULL, path = c(f1, f2), temp_files = c(f1, f2)),
    .package = "ckanr",
    {
      out <- ckan_fetch("https://example.com/data.zip", store = "session")
      expect_true(is.list(out))
      expect_named(out, c(basename(f1), basename(f2)))
    }
  )
  # disk branch
  testthat::with_mocked_bindings(
    fetch_GET = function(...) list(store = "disk", fmt = "csv", data = NULL, path = "/tmp/file.csv"),
    .package = "ckanr",
    {
      out <- ckan_fetch("https://example.com/data.csv", store = "disk", path = "/tmp/file.csv")
      expect_identical(out$path, "/tmp/file.csv")
    }
  )
})

test_that("read_session xls/xlsx/shp/geojson/parquet branches", {
  testthat::skip_if_not_installed("readxl")
  # xls single + multi via mocked readxl
  testthat::with_mocked_bindings(
    excel_sheets = function(...) "Sheet1",
    read_excel = function(...) data.frame(a = 1),
    .package = "readxl",
    {
      out <- ckanr:::read_session("xls", NULL, tempfile())
      expect_s3_class(out, "data.frame")
      out2 <- ckanr:::read_session("xlsx", NULL, tempfile())
      expect_s3_class(out2, "data.frame")
    }
  )
  testthat::with_mocked_bindings(
    excel_sheets = function(...) c("S1", "S2"),
    read_excel = function(...) data.frame(a = 1),
    .package = "readxl",
    {
      out <- ckanr:::read_all_excel_sheets(tempfile())
      expect_true(is.list(out))
      expect_named(out, c("S1", "S2"))
    }
  )
  testthat::skip_if_not_installed("sf")
  testthat::with_mocked_bindings(
    st_read = function(...) data.frame(geometry = 1),
    .package = "sf",
    {
      expect_s3_class(suppressMessages(ckanr:::read_session("shp", NULL, tempfile())), "data.frame")
      expect_s3_class(suppressMessages(ckanr:::read_session("geojson", NULL, tempfile())), "data.frame")
    }
  )
  testthat::skip_if_not_installed("arrow")
  pq <- system.file("examples", "iris.parquet", package = "ckanr")
  testthat::skip_if(!file.exists(pq), "parquet example missing")
  expect_s3_class(suppressMessages(ckanr:::read_session("parquet", NULL, pq)), "data.frame")
})

test_that("read_csv_base EOF warning fallback", {
  # triggers 'EOF within quoted string' warning inside read.csv
  csv <- 'a,b\n1,"unclosed\n2,3\n'
  df <- suppressWarnings(ckanr:::read_csv_base(text = csv))
  expect_true(is.data.frame(df))
})

test_that("ckan_VERB branches via mocked HttpClient", {
  CANNED <- '{"success":true,"result":{"id":"x"}}'
  mk_res <- function() {
    r <- new.env(parent = emptyenv())
    r$status_code <- 200
    r$parse <- function(...) CANNED
    r$status_http <- function() list(message = "OK")
    r
  }
  mk_con <- function(capture) {
    con <- new.env(parent = emptyenv())
    con$headers <- list()
    con$proxies <- NULL
    con$verb <- function(verb, ...) {
      capture$verb <- verb
      mk_res()
    }
    con$get <- function(...) mk_res()
    con$post <- function(...) mk_res()
    con
  }
  FakeClient <- list(new = function(...) mk_con(new.env()))
  # PATCH and DELETE wrappers
  testthat::with_mocked_bindings(
    HttpClient = FakeClient,
    .package = "crul",
    {
      expect_type(ckanr:::ckan_PATCH("https://example.com", "m", body = list(a = 1)), "character")
      expect_type(ckanr:::ckan_DELETE("https://example.com", "m"), "character")
      # no-auth with body and without body
      expect_type(ckanr:::ckan_VERB("get", "https://example.com", "m", NULL, NULL), "character")
      expect_type(ckanr:::ckan_VERB("post", "https://example.com", "m", list(a = 1), NULL), "character")
      # auth with and without body
      expect_type(ckanr:::ckan_VERB("get", "https://example.com", "m", NULL, "key"), "character")
      expect_type(ckanr:::ckan_VERB("post", "https://example.com", "m", list(a = 1), "key"), "character")
    }
  )
  # proxy invalid errors
  old_proxy <- get("ckanr_proxy", envir = ckanr:::ckanr_settings_env)
  on.exit(assign("ckanr_proxy", old_proxy, envir = ckanr:::ckanr_settings_env), add = TRUE)
  assign("ckanr_proxy", list(foo = "bar"), envir = ckanr:::ckanr_settings_env)
  expect_error(ckanr:::ckan_VERB("get", "https://example.com", "m", NULL, NULL), "proxy must be")
  expect_error(ckanr:::fetch_GET("https://example.com/x.csv", "session", tempfile()), "proxy must be")
  assign("ckanr_proxy", NULL, envir = ckanr:::ckanr_settings_env)
})

test_that("fetch_GET session and disk branches via mocked HttpClient", {
  # session csv (in-memory) branch
  fake_res_mem <- list(
    status_code = 200,
    parse = function(...) "a,b\n1,2\n",
    status_http = function() list(message = "OK")
  )
  fake_con_mem <- list(
    headers = list(), proxies = NULL,
    get = function(...) fake_res_mem
  )
  testthat::with_mocked_bindings(
    HttpClient = list(new = function(...) fake_con_mem),
    .package = "crul",
    {
      out <- ckanr:::fetch_GET("https://example.com/data.csv", "session", tempfile(), format = "csv")
      expect_identical(out$fmt, "csv")
      expect_match(out$data, "a,b")
    }
  )
  # session xls branch (disk download)
  tmp_xls <- tempfile(fileext = ".xls")
  writeLines("x", tmp_xls)
  fake_res_disk <- list(status_code = 200, content = tmp_xls)
  fake_con_disk <- list(
    headers = list(), proxies = NULL,
    get = function(...) fake_res_disk
  )
  testthat::with_mocked_bindings(
    HttpClient = list(new = function(...) fake_con_disk),
    .package = "crul",
    {
      out <- ckanr:::fetch_GET("https://example.com/f.xls", "session", tempfile(), format = "xls")
      expect_identical(out$fmt, "xls")
      out2 <- ckanr:::fetch_GET("https://example.com/f.zip", "disk", tempfile(), format = "zip")
      expect_identical(out2$store, "disk")
    }
  )
  # shp/zip branch with real zip containing csv (no shp -> fmt zip)
  zpath <- tempfile(fileext = ".zip")
  unlink(zpath)
  csv1 <- tempfile(fileext = ".csv")
  writeLines(c("a,b", "1,2"), csv1)
  utils::zip(zpath, files = csv1, flags = "-j -q")
  on.exit(unlink(c(zpath, csv1)), add = TRUE)
  fake_res_zip <- list(status_code = 200, content = zpath)
  fake_con_zip <- list(headers = list(), proxies = NULL, get = function(query = NULL, disk = NULL, ...) {
    if (!is.null(disk)) file.copy(zpath, disk, overwrite = TRUE)
    fake_res_zip
  })
  testthat::with_mocked_bindings(
    HttpClient = list(new = function(...) fake_con_zip),
    .package = "crul",
    {
      out <- ckanr:::fetch_GET("https://example.com/f.zip", "session", tempfile(), format = "zip")
      expect_identical(out$fmt, "zip")
    }
  )
})
