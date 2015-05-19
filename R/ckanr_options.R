#' Get or set ckanr options
#'
#' @export
#' @param url (character) A valid CKAN URL for testing purposes
#' @param key (character) A valid CKAN API key privileged to create datasets at URL
#' @param did (character) A valid CKAN dataset ID, existing at url
#' @param rid (character) A valid CKAN resource ID, attached to did
#' @return \code{ckanr_options} prints your base url, API key (if used), and optional
#' test server settings (URL, API key, a dataset ID and a resource ID).
#' \code{set_test_env} sets your test settings, while \code{get_test_url},
#' \code{get_test_key}, \code{get_test_did}, and \code{get_test_rid} get
#' each of those respective settings.
#' @seealso \code{\link{set_ckanr_url}}, \code{\link{get_ckanr_url}},
#' \code{\link{set_api_key}}
#' @family ckanr options
#' @details
#' \code{set_test_env}: Set options for CKAN test environment. Tests require a
#' valid CKAN URL, a privileged API key for that URL, plus the IDs of an existing
#' dataset and an existing resource, repectively. The settings are written as
#' environment variables.
#'
#' @examples
#' ckanr_options()
ckanr_options <- function() {
  ops <- list(url = Sys.getenv("CKANR_DEFAULT_URL", ""),
              key = Sys.getenv("X-CKAN-API-Key", ""),
              test_url = Sys.getenv("CKANR_TEST_URL", ""),
              test_key = Sys.getenv("CKANR_TEST_KEY", ""),
              test_did = Sys.getenv("CKANR_TEST_DID", ""),
              test_rid = Sys.getenv("CKANR_TEST_RID", "")
  )
  structure(ops, class = "ckanr_options")
}

#' @export
print.ckanr_options <- function(x, ...) {
  cat("<ckanr options>", sep = "\n")
  cat("  Base URL: ", x$url, "\n")
  cat("  API key: ", x$key, "\n")
  cat("  Test CKAN URL:", x$test_url, "\n")
  cat("  Test CKAN API key:", x$test_key, "\n")
  cat("  Test CKAN dataset ID:", x$test_did, "\n")
  cat("  Test CKAN resource ID:", x$test_rid)
}

#' @export
#' @rdname ckanr_options
set_test_env <- function(url, key, did, rid) {
  Sys.setenv(CKANR_TEST_URL = url)
  Sys.setenv(CKANR_TEST_KEY = key)
  Sys.setenv(CKANR_TEST_DID = did)
  Sys.setenv(CKANR_TEST_RID = rid)
}

#' @export
#' @rdname ckanr_options
get_test_url <- function(){
  Sys.getenv("CKANR_TEST_URL")
}

#' @export
#' @rdname ckanr_options
get_test_key <- function(){
  Sys.getenv("CKANR_TEST_KEY")
}

#' @export
#' @rdname ckanr_options
get_test_did <- function(){
  Sys.getenv("CKANR_TEST_DID")
}

#' @export
#' @rdname ckanr_options
get_test_rid <- function(){
  Sys.getenv("CKANR_TEST_RID")
}
