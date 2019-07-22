#' List datasets.
#'
#' @export
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' package_list()
#' package_list(as = 'json')
#' package_list(as = 'table')
#'
#' package_list(url = 'http://data.nhm.ac.uk')
#' }
package_list <- function(offset = 0, limit = 31, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(offset = offset, limit = limit))
  res <- ckan_GET(url, 'package_list', args, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
