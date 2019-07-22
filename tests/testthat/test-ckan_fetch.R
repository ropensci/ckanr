context("ckan_fetch")

skip_on_cran()

test_that("ckan_fetch returns error when file format can't be determined from URL", {
  expect_error(
    ckan_fetch("https://ckan0.cf.opendata.inter.sandbox-toronto.ca/datastore/dump/75c69a49-8573-4dda-b41a-d312a33b2e05"),
    "File format is not available from URL; please specify via `format` argument."
  )
})

test_that("ckan_fetch doesn't write any files to working directory when session = TRUE", {
  expect_identical(list.files(test_path()), {
    ckanr_setup("http://datamx.io")
    res <- resource_show(id = "e883510e-a082-435c-872a-c5b915857ae1", as = "table")
    df <- ckan_fetch(res$url)
    list.files(test_path())
  })
})

test_that("ckan_fetch doesn't retain any files in temporary directory when session = TRUE", {
  dir <- tempdir()
  expect_identical(list.files(dir), {
    ckanr_setup("http://datamx.io")
    res <- resource_show(id = "e883510e-a082-435c-872a-c5b915857ae1", as = "table")
    df <- ckan_fetch(res$url)
    list.files(dir)
  })
})
