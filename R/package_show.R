#' Show a package.
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
#' # create a package
#' (res <- package_create("purposeful"))
#'
#' # show package
#' package_show(res$id)
#'
#' # get data back in different formats
#' package_show(res$id, as = 'json')
#' package_show(res$id, as = 'table')
#'
#' # use default schema or not
#' package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', TRUE)
#' }
package_show <- function(id, use_default_schema = FALSE,
                         url = get_default_url(), as = 'list', ...) {
  body <- cc(list(id = id, use_default_schema = use_default_schema))
  res <- ckan_POST(url, 'package_show', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
