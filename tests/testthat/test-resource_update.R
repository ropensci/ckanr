context("resource_update")

file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
url <- Sys.getenv("ckan.demo.url")
key <- Sys.getenv("ckan.demo.key")
rid <- Sys.getenv("ckan.demo.resource.id")
a <- resource_update(id = rid, file, key)

test_that("resource_update gives back expected class types", {
  expect_is(a, "list")
  expect_is(a$resource_group_id, "character")
})

test_that("resource_update gives back expected output", {
#   expect_equal(a$name, "mydata")
#   expect_equal(a$format, "CSV")
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("resource_update fails well", {
  # all parameters missing
  expect_error(resource_update(), "argument \"path\" is missing, with no default")
  # 403 forbidden error
  expect_error(resource_update(rid, file, "badkey"), "Forbidden")
  # bad file path
  expect_error(resource_update(rid, "asdfasdf", key), "file does not exist")
})
