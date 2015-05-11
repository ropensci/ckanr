context("ds_search")

test_that("ds_search gives back expected class types", {
  a <- ds_search(resource_id='f4129802-22aa-4437-b9f9-8a8f3b7b2a53')
  expect_is(a, "list")
})

test_that("ds_search works giving back json output", {
  b <- ds_search(resource_id='f4129802-22aa-4437-b9f9-8a8f3b7b2a53', as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
