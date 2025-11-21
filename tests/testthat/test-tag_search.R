context("tag_search")

skip_on_cran()

u <- get_test_url()

test_that("tag_search gives back expected class types", {
  check_ckan(u)
  a <- tag_search(query = "a", url = u)
  expect_is(a, "list")
  expect_is(a[[1]], "ckan_tag")
  expect_named(a[[1]], c('vocabulary_id', 'id', 'name'), ignore.order = TRUE)
})

test_that("tag_search works with many queries", {
  check_ckan(u)
  a <- tag_search(query = c('c', 'ck'), url = u)
  expect_is(a, "list")
  expect_is(a[[1]], "ckan_tag")
  expect_named(a[[1]], c('vocabulary_id', 'id', 'name'), ignore.order = TRUE)
})

test_that("tag_search supports list/json/table formats", {
  check_ckan(u)
  expect_ckan_formats(function(fmt) {
    tag_search(query = c("ta", "al"), url = u, as = fmt)
  })
})
