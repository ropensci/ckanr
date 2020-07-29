context("ckanr utils")

skip_on_cran()

test_that("handle_many", {
  x <- c("stuff", "things")
  y <- list("stuff:foo", "things:bar")
  
  xa <- handle_many(x)
  expect_is(xa, "list")
  expect_named(xa, c("query", "query"))

  ya <- handle_many(y)
  expect_is(ya, "list")
  expect_named(ya, c("query", "query"))

  expect_error(handle_many(NA))
  expect_error(handle_many(5))
})
