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
#' (res <- package_create("purposeful55"))
#'
#' # show package
#' ## From the output of package_create
#' package_show(res)
#' ## Or, from the ID
#' package_show(res$id)
#'
#' # get data back in different formats
#' package_show(res$id, as = 'json')
#' package_show(res$id, as = 'table')
#'
#' # use default schema or not
#' package_show(res$id, TRUE)
#' }
package_show <- function(id, use_default_schema = FALSE,
                         url = get_default_url(), as = 'list', ...) {
  id <- as.ckan_package(id, url = url)
  body <- cc(list(id = id$id, use_default_schema = use_default_schema))
  res <- ckan_POST(url, 'package_show', body = tojun(body, TRUE), key = NULL,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"), table = jsd(res))
}
