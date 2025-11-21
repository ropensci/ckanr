context("resource_show")

skip_on_cran()

u <- get_test_url()

test_that("resource_show supports list/json/table formats", {
  check_ckan(u)
  resources <- resource_search("name:ckanr", url = u, limit = 1)
  if (length(resources$results) > 0) {
    res_id <- resources$results[[1]]$id
    expect_ckan_formats(function(fmt) {
      resource_show(res_id, url = u, as = fmt)
    })
  } else {
    skip("No resources available for testing")
  }
})
