#' List current packages with resources.
#'
#' @export
#'
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 31)
#' @template args
#' @examples \donttest{
#' package_list_current()
#' package_list_current(as='json')
#' package_list_current(as='table')
#' }
package_list_current <- function(offset = 0, limit = 31, url = get_ckanr_url(), as='list', ...)
{
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, 'current_package_list_with_resources', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
