context("ds_search")

skip_on_cran()

# u <- get_test_url()
u <- "http://data.nhm.ac.uk/"
# r <- get_test_rid()
r <- "8f0784a6-82dd-44e7-b105-6194e046eb8d"

if (r == "") {
  did <- package_list(limit = 1, url = u)[[1]]
  pkg <- package_show(did, url = u)
  r <- pkg$resources[[1]]$id
}

test_that("ds_search gives back expected class types", {
  check_ckan(u)
  check_resource(u,r)
  a <- ds_search(resource_id=r, url=u)

  expect_is(a, "list")
})

test_that("ds_search works giving back json output", {
  check_ckan(u)
  check_resource(u, r)
  b <- ds_search(resource_id=r, url=u, as="json")

  expect_is(b, "character")
  b_df <- jsonlite::fromJSON(b)
  expect_is(b_df, "list")
})
