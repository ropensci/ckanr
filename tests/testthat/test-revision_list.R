context("revision_list")

skip_on_cran()

u <- get_test_url()
ver <- try(ckan_version(u)$version_num, silent = TRUE)

if(ver >= 29.0) {
  test_that("removal of revision_list endpoint", {
    check_ckan(u)
    a <- expect_warning(revision_list(url=u), "The ckan.logic.action.get.revision_list endpoint was removed in CKAN 2.9. Returning NULL.")
    expect_null(a)
  })
} else {
  test_that("revision_list gives back expected class types", {
    check_ckan(u)
    a <- revision_list(url=u)
    expect_is(a, "list")
  })
  
  test_that("revision_list works giving back json output", {
    check_ckan(u)
    b <- revision_list(url=u, as="json")
    expect_is(b, "character")
    b_df <- jsonlite::fromJSON(b)
    expect_is(b_df, "list")
  })
}

