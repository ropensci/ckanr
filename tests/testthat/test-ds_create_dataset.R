context("ds_create_dataset")

file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
key <- Sys.getenv("CKAN_DEMO_KEY")
a <- ds_create_dataset(package_id = 'testingagain', name = "mydata", file, key)

test_that("ds_create_dataset gives back expected class types", {
  expect_is(a, "list")
  expect_is(a$resource_group_id, "character")
})

test_that("ds_create_dataset gives back expected output", {
  expect_equal(a$name, "mydata")
  expect_equal(a$format, "CSV")
  expect_true(grepl("actinidiaceae", a$url))
})

test_that("ds_create_dataset fails well", {
  # all parameters missing
  expect_error(ds_create_dataset(), "argument \"path\" is missing, with no default")
  # 403 forbidden error
  expect_error(ds_create_dataset('testingagain', "mydata", file, "badkey"), "Forbidden")
  # bad file path
  expect_error(ds_create_dataset('testingagain', "mydata", "asdfasdf", key), "file does not exist")
})
