#' Generic action function
#'
#' You must set the CKAN action and the HTTP verb.
#' You also set query parameters, body data, and headers.
#'
#' @export
#' @param action A valid CKAN API action name (for example, "package_list", "package_show"). See the CKAN API documentation for a full list of actions: https://docs.ckan.org/en/latest/api/index.html
#' @param query a named list of URL query parameters
#' @param body Data for the body of a request. See
#' https://docs.ropensci.org/crul/reference/verb-POST.html for options
#' @param headers a named list of request headers
#' @param verb HTTP request verb, for example, GET, POST
#' @param url Base url to use. Default: https://demo.ckan.org/ See
#' also [ckanr_setup()] and [get_default_url()]
#' @template key
#' @param ... Curl args. The function sends them to the relevant [crul::HttpClient] method for the `verb` parameter (optional)
#' @return A text string. The function returns text because the data type is unknown ahead of time. You parse the text as needed.
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
