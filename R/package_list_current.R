#' List current packages with resources.
#'
#' @export
#'
#' @template paging
#' @template args
#' @examples \dontrun{
#' package_list_current()
#' package_list_current(as = 'json')
#' package_list_current(as = 'table')
#' }
package_list_current <- function(offset = 0, limit = 31,
                                 url = get_default_url(), as = 'list', ...) {
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, 'current_package_list_with_resources', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
