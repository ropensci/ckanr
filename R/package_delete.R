#' Delete a package
#'
#' @export
#' @param id (character) The id of the package. Required.
#' @param url Base url to use. Default: https://data.ontario.ca
#' See also [ckanr_setup()] and [get_default_url()]
#' @param ... Curl args passed on to [crul::verb-POST] (optional)
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
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
package_delete <- function(id, url = get_default_url(),
  key = get_default_key(), ...) {

  id <- as.ckan_package(id, url = url, key = key)
  tmp <- ckan_POST(url, 'package_delete', body = list(id = id$id), key = key,
    opts = list(...))
  jsonlite::fromJSON(tmp)$success
}
