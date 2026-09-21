#' Search for resources.
#'
#' @export
#'
#' @param q Query terms. The value is a string of the form `field:term`
#' or a vector or list of strings. Each string uses the same form.
#' `field` is a field or extra field on the Resource domain object.
#' If `field` is hash, the function matches the `term` as a prefix
#' of the Resource.hash field. If `field` is an extra field, the function
#' matches against the extra fields stored against the Resource.
#' @param sort Field to sort on. You can specify ascending (for example,
#' score desc) or descending (for example, score asc). You can sort by two
#' fields (for example, score desc, price asc). You can sort by a function
#' (for example, sum(x_f, y_f) desc). The function sorts by the sum of x_f
#' and y_f in descending order.
#' @param offset Record to start at. The default is the beginning.
#' @param limit Number of records to return.
#' @template args
#' @template key
#' @examples \dontrun{
#' resource_search(q = "name:data")
#' resource_search(q = "name:data", as = "json")
#' resource_search(q = "name:data", as = "table")
#' resource_search(q = "name:data", limit = 2, as = "table")
#' resource_search(q = c("description:encoded", "name:No.2"), url = "demo.ckan.org")
#' }
resource_search <- function(
  q, sort = NULL, offset = NULL, limit = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  args <- cc(list(order_by = sort, offset = offset, limit = limit))
  args <- c(args, handle_many(q))
  res <- ckan_GET(url, "resource_search", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = {
      tmp <- jsl(res)
      tmp$results <- lapply(tmp$results, as.ckan_resource)
      tmp
    },
    table = jsd(res)
  )
}
