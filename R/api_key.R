#' Set API KEY of CKAN
#'
#' Some CKAN API functions require authentication.
#' The \code{set_api_key} is a helper function to set the api key and
#' enable authentication.
#'
#' @details
#'
#' The \code{ckanr} will check the value of global options \code{X-CKAN-API-Key}
#' before communicating with CKAN server. If the value is not \code{NULL}, the
#' \code{ckanr} will use the value as api key to authenticate with CKAN service.
#'
#' @param api_key (character). The api key of the user.
#' @examples
#' \dontrun{
#' set_api_key("xxx")
#' # list the private resources authorized to the above api key
#' organization_show("some_name", include_datasets = TRUE)[["packages"]]
#' }
#' @export
set_api_key <- function(api_key) {
  options("X-CKAN-API-Key" = api_key)
}

#' Enable Authentication with API-KEY
#'
#' Some CKAN API functions require authentication.
#' The \code{set_api_key} is a helper function to set the API-KEY and
#' the \code{api_key} is a helper function to enable authentication.
#' @importFrom httr add_headers
api_key <- function() {
  value <- getOption("X-CKAN-API-Key", NULL)
  if (is.null(value)) NULL else add_headers("X-CKAN-API-Key" = value)
}
