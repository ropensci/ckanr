context("ds_search_sql")

test_that("ds_search_sql gives back expected class types", {
  sql = 'SELECT * from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
  a <- ds_search_sql(sql)
  expect_is(a, "list")
})

test_that("ds_search_sql works giving back json output", {
  sql = 'SELECT * from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
  b <- ds_search_sql(sql, as = "json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
