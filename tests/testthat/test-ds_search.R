context("ds_search")
u <- get_test_url()

test_that("ds_search gives back expected class types", {
  check_ckan(u)
  p <- package_show(get_test_did(), url = u)
  r <- p$resources[[1]]$id
  check_resource(u,r)
  a <- ds_search(resource_id=r, url=u)

  expect_is(a, "list")
})

test_that("ds_search works giving back json output", {
  check_ckan(u)
  p <- package_show(get_test_did(), url = u)
  r <- p$resources[[1]]$id
  check_resource(u, r)
  b <- ds_search(resource_id=r, url=u, as="json")

  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
