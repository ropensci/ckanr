#' Test whether the configured test CKAN is offline
#'
#' @keywords internal
#' @importFrom testthat skip
#' @details
#' \code{check_ckan} will allow a test to fail (and not hide error messages)
#' if \code{ckanr_setup(test_strict="TRUE")} was set.
#' \code{check_ckan} will allow a test to skip (and the test suite to pass)
#' if \code{ckanr_setup(test_strict)} was set to anything but the string "TRUE".
#' @param url A URL that shall be tested whether it is online
#'
check_ckan <- function(url){
  # Strict tests shall not skip if there's problems with CKAN

  if (get_test_behaviour()=="SKIP" && !ping(url)) {
    skip(paste("CKAN is offline.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does the test CKAN server run at", url, "?"))
  }
}

#' Test whether the configured test CKAN resource exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_resource <- function(url, x){
  res <- resource_show(x, url = url)
  if (get_test_behaviour()=="SKIP" && !is(res, "list") && res$id != x) {
    skip(paste("The CKAN test resource wasn't found.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does a resource with ID", x, "exist on", url, "?"))
  }
}

#' Test whether the configured test CKAN dataset exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_dataset <- function(url, x){
  d <- package_show(x, url = url)
  if (get_test_behaviour()=="SKIP" && !is(d, "list") && d$id != x) {
    skip(paste("The CKAN test dataset wasn't found.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does a dataset with ID", x, "exist on", url, "?"))
  }
}

#' Test whether the configured test CKAN group exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_group <- function(url, x){
  grp <- group_show(x, url = url)
  if (get_test_behaviour()=="SKIP" && !is(grp, "list") && grp$id != x) {
    skip(paste("The CKAN test group wasn't found.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does a dataset with slug", x, "exist on", url, "?"))
  }
}

#' Test whether the configured test CKAN group exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_organization <- function(url, x){
  org <- organization_show(x, url = url)
  if (get_test_behaviour()=="SKIP" && !is(org, "list") && grp$id != x) {
    skip(paste("The CKAN test group wasn't found.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does an organization with slug", x, "exist on", url, "?"))
  }
}
