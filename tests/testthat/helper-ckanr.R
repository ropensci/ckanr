#' Given a TEST_API_KEY, create test resources on a CKAN site
#'
#' @keywords internal
#' @details
#' \code{prepare_test_ckan} creates an example dataset, resource, organisation,
#' and group on \code{localhost:5000} for the test suite to use, and runs \code{ckanr_setup}
#' with the respective IDs.
#'
#' The prerequisites for the tester is to run a CKAN site at
#' \code{localhost:5000} and provide the API key as R environment variable
#' \code{TEST_API_KEY}.
#'
#' This function aims to simplify using \code{localhost:5000} as test instance.
#' @param test_url A test CKAN instance where we are allowed to create dummy resources
#' @param test_key A working API key for an account on the test instance
prepare_test_ckan <- function(test_url = "http://localhost:5000",
                              test_key = Sys.getenv("TEST_API_KEY")){
  if (test_key == "") {
    message("Please provide your API key as parameter 'test_key' or via Sys.setenv(TEST_API_KEY = \"my-api-key\")")
    ckanr_setup(test_url=test_url)
  } else {
    message("Setting up test CKAN instance...")
    # An example CSV file which should upload fine to the datastore
    path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

    # Save ourselves from using test_url and test_key
    ckanr_setup(url = test_url, key = test_key)

    try(organization_create(name = "ckanr_test_org",
                            title = "ckanr test org",
                            url = test_url,
                            key = test_key),
        silent = TRUE)
    o <- organization_show(id = "ckanr_test_org")

    try(group_create(name = "ckanr_test_group",
                     url = test_url,
                     key = test_key),
        silent = TRUE)
    g <- group_show(id = "ckanr_test_group")

    try(package_create(name = "ckanr_test_dataset",
                       title = "ckanr test dataset",
                       owner_org = o$id,
                       tags = list(list("name" = "ckanr"),
                                   list("name" = "test")),
                       url = test_url,
                       key = test_key),
        silent = TRUE)
    p <- package_show(id = "ckanr_test_dataset")

    r <- resource_create(package_id = p$id,
                         description = "my resource",
                         name = "ckanr test resource",
                         upload = path,
                         rcurl = "http://google.com")

    # Tags should get an entry in ckanr_setup / ckanr_settings
    # t <- tag_create(name = "web", vocabulary_id = "Testing1") ## 403
    # t <- tag_list()[[1]]

    # All together now
    ckanr_setup(
      url = test_url,
      key = test_key,
      test_url = test_url,
      test_key = test_key,
      test_did = p$id,
      test_rid = r$id,
      test_oid = o$id,
      test_gid = g$id
    )
    message("CKAN test instance is set up.")
  }

}

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

ok_group <- function(url, x){
  grp <- tryCatch(group_show(x, url = url), error = function(e) e)
  !inherits(grp, "error")
}

#' Test whether the configured test CKAN group exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_organization <- function(url, x){
  org <- organization_show(x, url = url)
  if (get_test_behaviour()=="SKIP" && !is(org, "list") && org$id != x) {
    skip(paste("The CKAN test group wasn't found.",
               "Did you set CKAN test settings with ?ckanr_setup ?",
               "Does an organization with slug", x, "exist on", url, "?"))
  }
}

u <- get_test_url()

if (ping(u)) {
  prepare_test_ckan()
} else {
  message("CKAN is offline. Running tests that don't depend on CKAN.")
}
