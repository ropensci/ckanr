#' Delete a package
#'
#' @export
#' @param id (character) The id of the package. Required.
#' @template key
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.
#' @param ... Curl args passed on to \code{\link[httr]{POST}} (optional)
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("lions-bears-tigers"))
#'
#' # show the package
#' package_show(res)
#'
#' # delete the package
#' package_delete(res)
#' }
package_delete <- function(id, key = get_default_key(), url = get_default_url(), ...) {
  id <- as.ckan_package(id, url = url)
  tmp <- ckan_POST(url, 'package_delete', body = list(id = id$id), key = key, ...)
  jsonlite::fromJSON(tmp)$success
}
