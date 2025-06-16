ckanr_settings_env <- new.env()
# ls(envir = ckanr_settings_env)
# get("ckanr_proxy", ckanr_settings_env)
assign("ckanr_proxy", NULL, envir = ckanr_settings_env)

#' Get or set ckanr CKAN settings
#'
#' @export
#' @return `ckanr_settings` prints your base url, API key (if used), and
#' optional test server settings (URL, API key, a dataset ID and a resource ID).
#' `ckanr_setup` sets your production and test settings, while
#' `get_test_*` get each of those respective settings.
#' `test_behaviour` indicates whether the CKANR test suite will skip
#' ("SKIP") or fail ("FAIL") writing tests in case the configured test
#' CKAN settings don't work.
#' @seealso  [ckanr_setup()],
#' [get_default_url()], [get_default_key()], [get_test_url()],
#' [get_test_key()], [get_test_did()], [get_test_rid()],
#' [get_test_gid()], `get_test_oid`, `get_test_behaviour`
#' @family ckanr settings
#' @examples
#' ckanr_settings()
ckanr_settings <- function() {
  ops <- list(url = Sys.getenv("CKANR_DEFAULT_URL", ""),
              key = Sys.getenv("CKANR_DEFAULT_KEY", ""),
              test_url = Sys.getenv("CKANR_TEST_URL", ""),
              test_key = Sys.getenv("CKANR_TEST_KEY", ""),
              test_did = Sys.getenv("CKANR_TEST_DID", ""),
              test_rid = Sys.getenv("CKANR_TEST_RID", ""),
              test_gid = Sys.getenv("CKANR_TEST_GID", ""),
              test_oid = Sys.getenv("CKANR_TEST_OID", ""),
              test_behaviour = Sys.getenv("CKANR_TEST_BEHAVIOUR", ""),
              proxy = get("ckanr_proxy", ckanr_settings_env)
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
  cat("  Test CKAN resource ID:", x$test_rid, "\n")
  cat("  Test CKAN group ID:", x$test_gid, "\n")
  cat("  Test CKAN organization ID:", x$test_oid, "\n")
  cat("  Test behaviour if CKAN offline:", x$test_behaviour, "\n")
  px_val <- NULL
  # px <- get("ckanr_proxy", ckanr_settings_env)
  if (!is.null(x$proxy)) {
    px <- unclass(x$proxy)
    px_val <- sprintf("%s:%s", px$options$proxy, px$options$proxyport)
  }
  cat("  Proxy:", px_val)
}

#------------------------------------------------------------------------------#
# Setters
#
#' Configure default CKAN settings
#'
#' @export
#' @param url A CKAN URL (optional), default: https://data.ontario.ca
#' @param key A CKAN API key (optional, character)
#' @param test_url (optional, character) A valid CKAN URL for testing purposes
#' @param test_key (optional, character) A valid CKAN API key privileged to
#' create datasets at `test_url`
#' @param test_did (optional, character) A valid CKAN dataset ID, existing at
#' `test_url`
#' @param test_rid (optional, character) A valid CKAN resource ID, attached to
#' `did`
#' @param test_gid (optional, character) A valid CKAN group name at `test_url`
#' @param test_oid (optional, character) A valid CKAN organization name at
#' `test_url`
#' @param test_behaviour (optional, character) Whether to fail ("FAIL") or skip
#' ("SKIP") writing tests in case of problems with the configured test CKAN.
#' @param proxy an object of class `request` from a call to 
#' [crul::proxy()]
#' @details
#' [ckanr_setup()] sets CKAN connection details. ckanr's functions
#' default to use the default URL and API key unless specified explicitly.
#'
#' ckanr's automated tests require a valid CKAN URL, a privileged API key
#' for that URL, plus the IDs of an existing dataset and an existing resource,
#' respectively.
#'
#' The writing tests (create, update, delete) can fail for two reasons:
#' failures in ckanr's code which the tests aim to detect,
#' or failures in the configured CKAN, which are not necessarily a problem
#' with ckanr's code but prevent the tests to prove otherwise.
#'
#' Setting `test_behaviour` to `"SKIP"` will allow writing tests to skip
#' if the configured test CKAN fails. This is desirable to e.g. test the other
#' functions even if the tester has no write access to a CKAN instance.
#'
#' Setting `test_behaviour` to `"FAIL"` will let the tester find any
#' problems with both the configured test CKAN and the writing functions.
#'
#' @examples
#' # CKAN users without admin/editor privileges could run:
#' ckanr_setup(url = "https://data.ontario.ca/")
#'
#' # Privileged CKAN editor/admin users can run:
#' ckanr_setup(url = "https://data.ontario.ca/", key = "some-CKAN-API-key")
#'
#' # ckanR developers/testers can run:
#' ckanr_setup(url = "https://data.ontario.ca/", key = "some-CKAN-API-key",
#'            test_url = "http://test-ckan.gov/",test_key = "test-ckan-API-key",
#'            test_did = "test-ckan-dataset-id",test_rid = "test-ckan-resource-id",
#'            test_gid = "test-group-name", test_oid = "test-organzation-name",
#'            test_behaviour = "FAIL")
#'
#' # Not specifying the default CKAN URL will reset the CKAN URL to its default
#' # "https://data.ontario.ca/":
#' ckanr_setup()
#' 
#' # set a proxy
#' ckanr_setup(proxy = crul::proxy("64.251.21.73:8080"))
#' ckanr_settings()
#' ## run without setting proxy to reset to no proxy
#' ckanr_setup()
#' ckanr_settings()
ckanr_setup <- function(
  url = "https://data.ontario.ca/",
  key = NULL,
  test_url = NULL,
  test_key = NULL,
  test_did = NULL,
  test_rid = NULL,
  test_gid = NULL,
  test_oid = NULL,
  test_behaviour = NULL,
  proxy = NULL) {

  Sys.setenv("CKANR_DEFAULT_URL" = url)
  if (!is.null(key)) Sys.setenv("CKANR_DEFAULT_KEY" = key)
  if (!is.null(test_url)) Sys.setenv("CKANR_TEST_URL" = test_url)
  if (!is.null(test_key)) Sys.setenv("CKANR_TEST_KEY" = test_key)
  if (!is.null(test_did)) Sys.setenv("CKANR_TEST_DID" = test_did)
  if (!is.null(test_rid)) Sys.setenv("CKANR_TEST_RID" = test_rid)
  if (!is.null(test_gid)) Sys.setenv("CKANR_TEST_GID" = test_gid)
  if (!is.null(test_oid)) Sys.setenv("CKANR_TEST_OID" = test_oid)
  if (!is.null(test_behaviour)) Sys.setenv("CKANR_TEST_BEHAVIOUR" = test_behaviour)
  assign("ckanr_proxy", proxy, envir = ckanr_settings_env)
}

#------------------------------------------------------------------------------#
# Getters
#
#' @export
#' @rdname ckanr_settings
get_default_url <- function(){ Sys.getenv("CKANR_DEFAULT_URL") }

#' @export
#' @rdname ckanr_settings
get_default_key <- function(){ Sys.getenv("CKANR_DEFAULT_KEY") }

#' @export
#' @rdname ckanr_settings
get_test_url <- function(){ Sys.getenv("CKANR_TEST_URL") }

#' @export
#' @rdname ckanr_settings
get_test_key <- function(){ Sys.getenv("CKANR_TEST_KEY") }

#' @export
#' @rdname ckanr_settings
get_test_did <- function(){ Sys.getenv("CKANR_TEST_DID") }

#' @export
#' @rdname ckanr_settings
get_test_rid <- function(){ Sys.getenv("CKANR_TEST_RID") }

#' @export
#' @rdname ckanr_settings
get_test_gid <- function(){ Sys.getenv("CKANR_TEST_GID") }

#' @export
#' @rdname ckanr_settings
get_test_oid <- function(){ Sys.getenv("CKANR_TEST_OID") }

#' @export
#' @rdname ckanr_settings
get_test_behaviour <- function(){ Sys.getenv("CKANR_TEST_BEHAVIOUR") }
