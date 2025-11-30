#' Generic action function
#'
#' You have to set the CKAN action to use, as well as the HTTP verb,
#' in addition to any query parameters, request body data, and
#' request headers.
#'
#' @export
#' @param action A valid CKAN API action name (e.g., "package_list", "package_show"). See the CKAN API documentation for a full list of actions: https://docs.ckan.org/en/latest/api/index.html
#' @param query a named list of URL query parameters
#' @param body data to be used in the body of a request, see
#' https://docs.ropensci.org/crul/reference/verb-POST.html for options
#' @param headers a named list of request headers
#' @param verb HTTP request verb, e.g., GET, POST
#' @param url Base url to use. Default: https://demo.ckan.org/ See
#' also [ckanr_setup()] and [get_default_url()]
#' @template key
#' @param ... Curl args passed on to the relevant [crul::HttpClient] method depending on the `verb` parameter (optional)
#' @return a text string. because we can't know ahead of time for sure
#' what kind of data will be returned, we return text and the user
#' can parse as needed.
#' @examples \dontrun{
#' ckanr_setup(
#'   url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key")
#' )
#'
#' ckan_action("package_list")
#' ckan_action("package_list", verb = "GET")
#' ckan_action("package_list", url = "https://data.nhm.ac.uk")
#' }
ckan_action <- function(
  action, query = NULL, body = NULL,
  headers = list(), verb = "POST", url = get_default_url(),
  key = get_default_key(), ...
) {
  ckan_VERB(verb, url, action,
    body = body, key = key,
    query = query, headers = headers, opts = list(...)
  )
}
