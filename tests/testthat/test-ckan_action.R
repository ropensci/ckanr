context("ckan_action")

skip_on_cran()

test_that("ckan_action works", {
  aa <- ckan_action("package_list")
  expect_is(aa, "character")
  res <- jsonlite::fromJSON(aa)
  expect_is(res, "list")
  expect_named(res, c("help", "success", "result"))
})

test_that("ckan_action errors well", {
  # not an acceptable ckan action
  expect_error(ckan_action("foo_bar"))
  # not an acceptable http verb
  expect_error(ckan_action("foo_bar", verb = "FLOB"))
})
