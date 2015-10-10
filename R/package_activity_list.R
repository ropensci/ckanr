#' Return a list of the package's activity
#'
#' @export
#' @param id (character) Package identifier.
#' @template paging
#' @template args
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("owls6"))
#'
#' # list package activity
#' package_activity_list(res$id)
#'
#' # make a change
#' x <- list(maintainer = "Jane Forest")
#' package_update(x, res)
#'
#' # list activity again
#' package_activity_list(res)
#'
#' # output different data formats
#' package_activity_list(res$id, as = "table")
#' package_activity_list(res$id, as = "json")
#' }
package_activity_list <- function(id, offset = 0, limit = 31,
                                  url = get_default_url(), as = "list", ...) {
  id <- as.ckan_package(id, url = url)
  body <- cc(list(id = id$id, offset = offset, limit = limit))
  res <- ckan_POST(url, 'package_activity_list', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
