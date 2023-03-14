context("package_revision_list")

skip_on_cran()

u <- get_test_url()
ver <- try(ckan_version(u)$version_num, silent = TRUE)

if (ver >= 29.0) {
  test_that("removal of package_revision_list endpoint", {
    check_ckan(u)
    a <- expect_warning(package_revision_list(url=u), "The ckan.logic.action.get.package_revision_list endpoint was removed in CKAN 2.9. Returning NULL.")
    expect_null(a)
  })  
} else {
  test_that("package_revision_list gives back expected class types", {
    check_ckan(u)
    .a <- package_list_current(limit=1, url=u)
    a <- package_revision_list(.a[[1]]$id, url=u)
    expect_is(a, "list")
  })
  
  test_that("package_revision_list works giving back json output", {
    check_ckan(u)
    .b <- package_list_current(limit=1, url=u)
    b <- package_revision_list(.b[[1]]$id, url=u, as="json")
    b_df <- jsonlite::fromJSON(b)
    expect_is(b, "character")
    expect_is(b_df, "list")
    expect_is(b_df$result, "data.frame")
  })
}

