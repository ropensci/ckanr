#' Search for resources.
#'
#' @export
#'
#' @param q Query terms. It is a string of the form `field:term` or a
#' vector/list of strings, each of the same form.  Within each string, `field`
#' is a field or extra field on the Resource domain object. If `field` is
#' hash, then an attempt is made to match the `term` as a *prefix* of the
#' Resource.hash field. If `field` is an extra field, then an attempt is
#' made to match against the extra fields stored against the Resource.
#' @param sort Field to sort on. You can specify ascending (e.g., score desc)
#' or descending (e.g., score asc), sort by two fields (e.g., score desc,
#' price asc), or sort by a function (e.g., sum(x_f, y_f) desc, which sorts
#' by the sum of x_f and y_f in a descending order).
#' @param offset Record to start at, default to beginning.
#' @param limit Number of records to return.
#' @template args
#' @template key
#' @examples \dontrun{
#' resource_search(q = 'name:data')
#' resource_search(q = 'name:data', as = 'json')
#' resource_search(q = 'name:data', as = 'table')
#' resource_search(q = 'name:data', limit = 2, as = 'table')
#' resource_search(q=c("description:encoded", "name:No.2"),url='demo.ckan.org')
#' }
resource_search <- function(q, sort = NULL, offset = NULL, limit = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  args <- cc(list(order_by = sort, offset = offset, limit = limit))
  args <- c(args, handle_many(q))
  res <- ckan_GET(url, 'resource_search', args, key = key, opts = list(...))
  switch(as, json = res,
         list = {
           tmp <- jsl(res)
           tmp$results <- lapply(tmp$results, as.ckan_resource)
           tmp
         },
         table = jsd(res))
}
