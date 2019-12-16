#' Show a package.
#'
#' @export
#'
#' @param id (character/ckan_package) Package identifier, or a `ckan_package`
#' object
#' @param use_default_schema (logical) Use default package schema instead of a
#' custom schema defined with an IDatasetForm plugin. Default: `FALSE`
#' @param http_method (character) which HTTP method (verb) to use; one of 
#' "GET" or "POST". Default: "GET"
#' @template args
#' @template key
#' @details By default the help and success slots are dropped, and only the
#' result slot is returned. You can request raw json with `as = 'json'`
#' then parse yourself to get the help slot.
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key"))
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
package_show <- function(id, use_default_schema = FALSE, http_method = "GET",
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  assert(id, c("character", "ckan_package"))
  check_http_method(http_method, c("GET", "POST"))
  if (inherits(id, "ckan_package")) id <- id$id
  args <- cc(list(id = id, use_default_schema = use_default_schema))
  fun <- switch(http_method, GET = ckan_GET, POST = ckan_POST)
  res <- fun(url, 'package_show', args, key = key, opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"),
         table = jsd(res))
}
