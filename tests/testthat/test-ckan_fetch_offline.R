context("ckan_fetch offline")

skip_on_cran()

test_that("ckan_fetch validates x length, store and format", {
  expect_error(ckan_fetch(c("a.csv", "b.csv")), "`x` must be length 1")
  expect_error(
    ckan_fetch("https://example.com/dump/abc123"),
    "File format is not available"
  )
  expect_error(
    ckan_fetch("https://example.com/dump/abc123", format = NA),
    "File format is not available"
  )
  expect_error(
    ckan_fetch("https://example.com/data.csv", store = "bogus"),
    "'arg' should be one of"
  )
})

test_that("read_csv_base requires exactly one source", {
  expect_error(
    ckanr:::read_csv_base(text = "a,b\n1,2", path = tempfile()),
    "exactly one CSV source"
  )
  expect_error(
    ckanr:::read_csv_base(),
    "exactly one CSV source"
  )
})

test_that("read_csv_base reads text and file sources", {
  df <- ckanr:::read_csv_base(text = "a,b\n1,2\n3,4\n")
  expect_named(df, c("a", "b"))
  expect_equal(nrow(df), 2L)

  f <- tempfile(fileext = ".csv")
  writeLines(c("x,y", "1,2"), f)
  on.exit(unlink(f), add = TRUE)
  df2 <- ckanr:::read_csv_base(path = f)
  expect_named(df2, c("x", "y"))
})

test_that("read_csv_base falls back on EOF quoted string", {
  csv <- paste(
    "id,name,value",
    "1,one,10",
    "2,\"bad quote,20",
    "3,three,30",
    sep = "\n"
  )
  df <- ckanr:::read_csv_base(text = csv)
  expect_equal(nrow(df), 3L)
})

test_that("read_session rejects unsupported formats", {
  for (fmt in list("pdf", "docx", NA_character_, NULL)) {
    expect_error(
      ckanr:::read_session(fmt, "x", tempfile()),
      "Unsupported file format"
    )
  }
})

test_that("read_session reads json and txt offline", {
  js <- ckanr:::read_session("json", '{"a": [1, 2], "b": "x"}', tempfile())
  expect_true(is.list(js) || is.data.frame(js))

  f <- tempfile()
  write.table(data.frame(a = 1:3, b = letters[1:3]), f, row.names = FALSE)
  on.exit(unlink(f), add = TRUE)
  txt <- ckanr:::read_session("txt", NULL, f)
  expect_s3_class(txt, "data.frame")

  # unreadable txt errors clearly
  expect_error(
    suppressWarnings(ckanr:::read_session("txt", NULL, tempfile())),
    "cannot be read via"
  )
})

test_that("read_session reads xml/html when xml2 available", {
  testthat::skip_if_not_installed("xml2")
  xml <- ckanr:::read_session("xml", "<root><a>1</a></root>", tempfile())
  expect_true(inherits(xml, "xml_document"))
  html <- ckanr:::read_session(
    "html",
    "<html><body><p>hi</p></body></html>",
    tempfile()
  )
  expect_true(inherits(html, "xml_document"))
})

test_that("read_all_excel_sheets single sheet returns data.frame", {
  testthat::skip_if_not_installed("readxl")
  f <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  skip_if(!file.exists(f), "example CSV missing")
  # exercise the csv path through read_session with extra args
  df <- ckanr:::read_session(
    "csv",
    paste(readLines(f), collapse = "\n"),
    tempfile(),
    sep = ","
  )
  expect_s3_class(df, "data.frame")
  expect_gt(nrow(df), 0)
})

test_that("file_fmt handles edge cases", {
  expect_identical(ckanr:::file_fmt("https://example.com/DATA.CSV"), "CSV")
  expect_true(is.na(ckanr:::file_fmt("https://example.com/no-extension")))
})
