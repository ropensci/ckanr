context("package_search")

test_that("package_search gives back expected class types", {
  a <- package_search(rows = 10)
  expect_is(a, "list")
  expect_less_than(length(a$results), 10 + 1)
  a2 <- package_search(rows = length(a$results))
  expect_is(a2, "list")
  expect_equal(length(a2$results), length(a$results))
})

test_that("package_search works giving back json output", {
  a <- package_search(rows = 10, as = "json")
  a_df <- jsonlite::fromJSON(a)
  expect_is(a, "character")
  expect_is(a_df, "list")
  expect_is(a_df$result$results, "data.frame")
})
