context("resource_show")

skip_on_cran()

u <- get_test_url()

test_that("resource_show gives back expected class types", {
  check_ckan(u)
  .a <- resource_search("name:ckanr", url=u, limit=1)
  if (length(.a$results) > 0) {
    a <- resource_show(.a$results[[1]]$id, url=u)
    expect_is(a, "ckan_resource")
  }
})

test_that("resource_show works giving back json output", {
  check_ckan(u)
  .b <- resource_search("name:ckanr", url=u, limit=1)
  if (length(.b$results) > 0) {
    b <- resource_show(.b$results[[1]]$id, url=u, as="json")
    expect_is(b, "character")
    b_df <- jsonlite::fromJSON(b)
    expect_is(b_df, "list")
  }
})
