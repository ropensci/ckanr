#' List datasets.
#'
#' @export
#'
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 31)
#' @template args
#' @examples \donttest{
#' datasets()
#' datasets(as='json')
#' datasets(as='table')
#' }
datasets <- function(offset = 0, limit = 31, url = 'http://data.techno-science.ca', as='list', ...)
{
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, method='package_list', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
