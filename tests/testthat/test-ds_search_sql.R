context("ds_search_sql")
u <- get_test_url()

test_that("ds_search_sql gives back expected class types", {
  check_ckan(u)
  p <- package_show(get_test_did(), url = u)
  r <- p$resources[[1]]$id
  check_resource(u,r)
  sql = paste0('SELECT * from "', r, '" LIMIT 2')
  a <- ds_search_sql(sql, url=u)
  expect_is(a, "list")
})

test_that("ds_search_sql works giving back json output", {
  check_ckan(u)
  p <- package_show(get_test_did(), url = u)
  r <- p$resources[[1]]$id
  check_resource(u,r)
  sql = paste0('SELECT * from "', r, '" LIMIT 2')
  b <- ds_search_sql(sql, url=u, as="json")
  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
