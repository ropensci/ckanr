#' Get ckanr options
#'
#' @export
#' @return Prints your base url, and API key (if used)
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
  cat("Test CKAN resource ID:", x$ckanr.test.rid)
}


#'  Set options for CKAN test environment
#'
#'  Tests require a valid CKAN URL, a privileged API key for that URL,
#'  plus the IDs of an existing dataset and an existing resource, repectively.
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
}

#' Get the CKAN test URL
#' @export
get_test_url <- function(){getOption("ckan.test.url", NULL)}

#' Get the CKAN test key
#' @export
get_test_key <- function(){getOption("ckan.test.key", NULL)}

#' Get the CKAN test dataset ID
#' @export
get_test_did <- function(){getOption("ckan.test.did", NULL)}

#' Get the CKAN resource ID
#' @export
get_test_rid <- function(){getOption("ckan.test.rid", NULL)}
