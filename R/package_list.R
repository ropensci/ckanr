#' List datasets.
#'
#' @export
#' @template paging
#' @template args
#' @examples \dontrun{
#' package_list()
#' package_list(as = 'json')
#' package_list(as = 'table')
#' }
package_list <- function(offset = 0, limit = 31, url = get_default_url(),
                         key = get_default_key(), as = 'list', ...) {
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, method = 'package_list', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
