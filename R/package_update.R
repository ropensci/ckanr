#' Update a package
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param use_default_schema (logical) Use default package schema instead of a
#'   custom schema defined with an IDatasetForm plugin. Default: FALSE
#' @template args
#' @details By default the help and success slots are dropped, and only the
#'   result slot is returned. You can request raw json with \code{as = 'json'}
#'   then parse yourself to get the help slot.
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # First, show a package
#' res <- package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf')
#'
#' # Make some changes
#' res$author <- "Jane Doe"
#'
#' # Then update the packge
#' package_update(res)
#' }
package_update <- function(id, url = get_default_url(), as = 'list', ...) {
  body <- cc(list(id = id, use_default_schema = use_default_schema))
  res <- ckan_POST(url, 'package_update', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
