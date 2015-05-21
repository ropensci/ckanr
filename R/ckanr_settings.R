#' Get or set ckanr CKAN settings
#'
#' @export
#' @return \code{ckanr_settings} prints your base url, API key (if used), and
#' optional test server settings (URL, API key, a dataset ID and a resource ID).
#' \code{setup_ckanr} sets your production and test settings, while
#' \code{get_test_url}, \code{get_test_key}, \code{get_test_did}, and
#' \code{get_test_rid} get each of those respective settings.
#' @seealso  \code{\link{setup_ckanr}}, \code{\link{set_ckanr_url}},
#' \code{\link{get_ckanr_url}}, \code{\link{set_api_key}},
#' \code{\link{get_test_url}}, \code{\link{get_test_key}},
#' \code{\link{get_test_did}}, \code{\link{get_test_rid}}.
#' @family ckanr settings
#' @examples
#' ckanr_settings()
ckanr_settings <- function() {
  ops <- list(url = Sys.getenv("CKANR_DEFAULT_URL", ""),
              key = Sys.getenv("CKANR_DEFAULT_KEY", ""),
              test_url = Sys.getenv("CKANR_TEST_URL", ""),
              test_key = Sys.getenv("CKANR_TEST_KEY", ""),
              test_did = Sys.getenv("CKANR_TEST_DID", ""),
              test_rid = Sys.getenv("CKANR_TEST_RID", "")
  )
  structure(ops, class = "ckanr_settings")
}

#' @export
print.ckanr_settings <- function(x, ...) {
  cat("<ckanr settings>", sep = "\n")
  cat("  Base URL: ", x$url, "\n")
  cat("  API key: ", x$key, "\n")
  cat("  Test CKAN URL:", x$test_url, "\n")
  cat("  Test CKAN API key:", x$test_key, "\n")
  cat("  Test CKAN dataset ID:", x$test_did, "\n")
  cat("  Test CKAN resource ID:", x$test_rid)
}

#------------------------------------------------------------------------------#
# Setters
#
#' Configure default CKAN settings
#'
#' @export
#' @param url A CKAN URL (optional), default: "http://data.techno-science.ca/"
#' @param key A CKAN API key (optional)
#' @param test_url (optional) A valid CKAN URL for testing purposes
#' @param test_key (optional) A valid CKAN API key privileged to create datasets
#'    at \code{test_url}
#' @param test_did (optional) A valid CKAN dataset ID, existing at \code{test_url}
#' @param test_rid (optional) A valid CKAN resource ID, attached to \code{did}
#' @details
#' \code{setup_ckanr} sets CKAN connection details. \code{ckanr}'s functions
#' default to use the default URL and API key unless specified explicitly.
#' \code{ckanr}'s automated tests require a valid CKAN URL, a privileged API key
#' for that URL, plus the IDs of an existing dataset and an existing resource,
#' repectively.
#' @usage
#' # CKAN users without admin/editor privileges could run either of:
#' setup_ckanr("http://data-demo.dpaw.wa.gov.au/")
#' setup_ckanr(url="http://data-demo.dpaw.wa.gov.au/")
#'
#' # Privileged CKAN editor/admin users can run either of:
#' setup_ckanr("http://data-demo.dpaw.wa.gov.au/", "some-CKAN-API-key")
#' setup_ckanr(url="http://data-demo.dpaw.wa.gov.au/", key="some-CKAN-API-key")
#' set_ckanr_url("http://data-demo.dpaw.wa.gov.au/"); set_api_key("some-CKAN-api-key")
#'
#' # ckanR developers/testers can run either of:
#' setup_ckanr("http://data-demo.dpaw.wa.gov.au/", "some-CKAN-API-key",
#'            "http://test-ckan.dpaw.wa.gov.au/","test-ckan-API-key",
#'            "test-ckan-dataset-id","test-ckan-resource-id")
#' setup_ckanr(url="http://data-demo.dpaw.wa.gov.au/", key="some-CKAN-API-key",
#'            test_url="http://test-ckan.dpaw.wa.gov.au/",test_key="test-ckan-API-key",
#'            test_did="test-ckan-dataset-id",test_rid="test-ckan-resource-id")
#'
#' # This will set the CKAN URL to its default:
#' setup_ckanr()
setup_ckanr <- function(
  url="http://data.techno-science.ca/",
  key=NULL,
  test_url=NULL,
  test_key=NULL,
  test_did=NULL,
  test_rid=NULL){
  Sys.setenv("CKANR_DEFAULT_URL" = url)
  if (!is.null(key)) Sys.setenv("CKANR_DEFAULT_KEY" = key)
  if (!is.null(test_url)) Sys.setenv("CKANR_TEST_URL" = test_url)
  if (!is.null(test_key)) Sys.setenv("CKANR_TEST_KEY" = test_key)
  if (!is.null(test_did)) Sys.setenv("CKANR_TEST_DID" = test_did)
  if (!is.null(test_rid)) Sys.setenv("CKANR_TEST_RID" = test_rid)
}

#------------------------------------------------------------------------------#
# Getters
#
#' @export
#' @rdname ckanr_settings
get_default_url <- function(){
  Sys.getenv("CKANR_DEFAULT_URL")
}

#' @export
#' @rdname ckanr_settings
get_default_key <- function(){
  Sys.getenv("CKANR_DEFAULT_KEY")
}

#' @export
#' @rdname ckanr_settings
get_test_url <- function(){
  Sys.getenv("CKANR_TEST_URL")
}

#' @export
#' @rdname ckanr_settings
get_test_key <- function(){
  Sys.getenv("CKANR_TEST_KEY")
}

#' @export
#' @rdname ckanr_settings
get_test_did <- function(){
  Sys.getenv("CKANR_TEST_DID")
}

#' @export
#' @rdname ckanr_settings
get_test_rid <- function(){
  Sys.getenv("CKANR_TEST_RID")
}

#------------------------------------------------------------------------------#
# Helpers
#

#' Enable CKAN API authentication with an API key
#'
#' Some CKAN API functions require authentication through the HTTP request header
#' \code{X-CKAN-API-Key}. \code{ckanR} stores the API key in an environment
#' variable \code{CKANR_DEFAULT_KEY}, set by \code{setup_ckanr},
#' to avoid namespace collisions.
#' \code{api_key} facilitates authentication by adding the configured API key
#' as the correctly named request header. It serves as default value in all
#' \code{ckanr} functions for convenience.
#' @importFrom httr add_headers
#' @keywords internal
api_key <- function(key = NULL) {
  if (!is.null(key)) {
    value <- key
  } else {
    value <- Sys.getenv("CKANR_DEFAULT_KEY", "")
  }
  if (nchar(value) == 0) {
    NULL
  } else {
    add_headers("X-CKAN-API-Key" = value)
  }
}
