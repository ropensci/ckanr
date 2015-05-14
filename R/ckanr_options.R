#' Get ckanr options
#'
#' @export
#' @return Prints your base url, API key (if used), and optional test server
#'  settings (URL, API key, a dataset ID and a resource ID)
#' @seealso \code{\link{set_ckanr_url}}, \code{\link{get_ckanr_url}},
#' \code{\link{set_api_key}}
#' @family ckanr options
#' @examples
#' ckanr_options()
ckanr_options <- function() {
  ops <- list(url = getOption("ckanr.default.url", NULL),
              key = getOption("X-CKAN-API-Key", NULL),
              ckanr.test.url = getOption("ckanr.test.url", NULL),
              ckanr.test.key = getOption("ckanr.test.key", NULL),
              ckanr.test.did = getOption("ckanr.test.did", NULL),
              ckanr.test.rid = getOption("ckanr.test.rid", NULL)
  )
  structure(ops, class = "ckanr_options")
}

#' @export
print.ckanr_options <- function(x) {
  cat("Base URL: ", x$url, "\n")
  cat("API key: ", x$key, "\n")
  cat("Test CKAN URL:", x$ckanr.test.url, "\n")
  cat("Test CKAN API key:", x$ckanr.test.key, "\n")
  cat("Test CKAN dataset ID:", x$ckanr.test.did, "\n")
  cat("Test CKAN resource ID:", x$ckanr.test.rid)
}


#'  Set options for CKAN test environment
#'
#'  Tests require a valid CKAN URL, a privileged API key for that URL,
#'  plus the IDs of an existing dataset and an existing resource, repectively.
#'
#'  The settings are written to both options and Sys.env. Testthat can only
#'  access Sys.env.
#'
#'  @param url A valid CKAN URL for testing purposes
#'  @param key A valid CKAN API key privileged to create datasets at URL
#'  @param did A valid CKAN dataset ID, existing at url
#'  @param rid A valid CKAN resource ID, attached to did
#'  @export
set_test_env <- function(url, key, did, rid) {
  options(ckanr.test.url = url)
  options(ckanr.test.key = key)
  options(ckanr.test.did = did)
  options(ckanr.test.rid = rid)
  Sys.setenv("ckanr.test.url" = url)
  Sys.setenv("ckanr.test.key" = key)
  Sys.setenv("ckanr.test.did" = did)
  Sys.setenv("ckanr.test.rid" = rid)
}

#' Get the CKAN test URL
#' @export
get_test_url <- function(){
  #getOption("ckanr.test.url")
  #ckanr_options()$ckanr.test.url
  Sys.getenv("ckanr.test.url")
}

#' Get the CKAN test key
#' @export
get_test_key <- function(){
  #getOption("ckanr.test.key")
  Sys.getenv("ckanr.test.key")
}

#' Get the CKAN test dataset ID
#' @export
get_test_did <- function(){
  #getOption("ckanr.test.did")
  Sys.getenv("ckanr.test.did")
}

#' Get the CKAN resource ID
#' @export
get_test_rid <- function(){
  #getOption("ckanr.test.rid")
  Sys.getenv("ckanr.test.rid")
}
