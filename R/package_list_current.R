#' List current packages with resources.
#'
#' @export
#'
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 31)
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc),
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of
#' x_f and y_f in a descending order).
#' @param groups (character) A list of names of the groups to return, if given only groups whose
#' names are in this list will be returned
#' @param all_fields (logical) Return full group dictionaries instead of just names. Default: FALSE
#' @template args
#' @examples \donttest{
#' package_list_current()
#' package_list_current(as='json')
#' package_list_current(as='table')
#' }
package_list_current <- function(offset = 0, limit = 31, url = 'http://data.techno-science.ca', as='list', ...)
{
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, 'current_package_list_with_resources', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
