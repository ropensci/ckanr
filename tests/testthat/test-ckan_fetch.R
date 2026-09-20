context("ckan_fetch")

skip_on_cran()

rid <- get_test_rid()

test_that("ckan_fetch returns error when file format can't be determined from URL", {
  expect_error(
    ckan_fetch("https://ckan0.cf.opendata.inter.sandbox-toronto.ca/datastore/dump/75c69a49-8573-4dda-b41a-d312a33b2e05"),
    "File format is not available from URL; please specify via `format` argument."
  )
})

test_that("ckan_fetch errors fast when format is NA", {
  expect_error(
    ckan_fetch("https://example.com/datastore/dump/75c69a49-8573-4dda-b41a-d312a33b2e05", format = NA),
    "File format is not available from URL"
  )
})

test_that("read_session errors on unsupported or missing format instead of returning NULL", {
  expect_error(
    ckanr:::read_session("pdf", "x", tempfile()),
    "Unsupported file format"
  )
  expect_error(
    ckanr:::read_session(NA_character_, "x", tempfile()),
    "Unsupported file format"
  )
  expect_error(
    ckanr:::read_session(NULL, "x", tempfile()),
    "Unsupported file format"
  )
})

test_that("read_session normalizes uppercase format", {
  res <- ckanr:::read_session("CSV", "a,b\n1,2\n", tempfile())
  expect_named(res, c("a", "b"))
  expect_equal(nrow(res), 1L)
})

u <- get_test_url()
check_ckan(u)

test_that("ckan_fetch doesn't write any files to working directory when session = TRUE", {
  expect_identical(list.files(test_path()), {
    res <- resource_show(id = rid)
    df <- ckan_fetch(res$url)
    list.files(test_path())
  })
})

test_that("ckan_fetch doesn't retain any files in temporary directory when session = TRUE", {
  dir <- tempdir()
  expect_identical(list.files(dir), {
    res <- resource_show(id = rid)
    df <- ckan_fetch(res$url)
    list.files(dir)
  })
})
