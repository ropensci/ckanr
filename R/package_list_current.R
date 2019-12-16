#' List current packages with resources.
#'
#' @export
#'
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' package_list_current()
#' package_list_current(as = 'json')
#' package_list_current(as = 'table')
#' }
package_list_current <- function(offset = 0, limit = 31, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(offset = offset, limit = limit))
  res <- ckan_GET(url, 'current_package_list_with_resources', args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
