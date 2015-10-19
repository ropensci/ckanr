#' List groups.
#'
#' @export
#'
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc),
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of
#' x_f and y_f in a descending order).
#' @param groups (character) A list of names of the groups to return, if given
#'    only groups whose names are in this list will be returned
#' @param all_fields (logical) Return full group dictionaries instead of just
#'    names. Default: FALSE
#' @template paging
#' @template args
#' @examples \dontrun{
#' group_list()
#' group_list(as = 'json')
#' group_list(as = 'table')
#' }
group_list <- function(offset = 0, limit = 31, sort = NULL, groups = NULL,
                       all_fields = FALSE, url = get_default_url(), as = 'list', ...) {

  body <- cc(list(offset = offset, limit = limit, sort = sort,
                  groups = groups, all_fields = as_log(all_fields)))
  res <- ckan_POST(url, 'group_list', body = body, ...)
  switch(as, json = res,
         list = lapply(jsl(res), as.ckan_group, url = url),
         table = jsd(res))
}
