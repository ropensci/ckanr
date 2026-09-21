#' List groups.
#'
#' @export
#'
#' @param sort Field to sort on. You can specify ascending order, for example score desc.
#' You can specify descending order, for example score asc. You can sort by two fields,
#' for example score desc, price asc. You can sort by a function, for example sum(x_f, y_f) desc.
#' The function then sorts by the sum of x_f and y_f in descending order.
#' @param groups (character) A list of names of the groups to return. If you give
#' this list, the function returns only groups with names in this list.
#' @param all_fields (logical) Return full group dictionaries instead of
#' names. Default: `FALSE`
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' group_list(limit = 3)
#' group_list(limit = 3, as = "json")
#' group_list(limit = 3, as = "table")
#' }
group_list <- function(
  offset = 0, limit = 31, sort = NULL, groups = NULL,
  all_fields = FALSE, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  args <- cc(list(
    offset = offset, limit = limit, sort = sort,
    groups = groups, all_fields = as_log(all_fields)
  ))
  res <- ckan_GET(url, "group_list", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = lapply(jsl(res), as.ckan_group, url = url),
    table = jsd(res)
  )
}
