context("ckan_fetch")

test_that("ckan_fetch returns error when file format can't be determined from URL", {
  expect_error(
    ckan_fetch("https://ckan0.cf.opendata.inter.sandbox-toronto.ca/datastore/dump/75c69a49-8573-4dda-b41a-d312a33b2e05"),
    "File format is not available from URL; please specify via `format` argument."
  )
})
