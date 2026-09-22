#' Show a group
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param include_datasets (logical) Include a list of the group's datasets.
#' Default: `TRUE`
#' @param include_users (logical) Include the group's users. CKAN 2.12 changed
#' the server default to `FALSE` regardless of the
#' `ckan.auth.public_user_details` setting
#' (<https://github.com/ckan/ckan/pull/9232>); ckanr defaults to `TRUE` to
#' preserve the historical behavior. The parameter is accepted on all
#' supported CKAN versions (2.9, 2.10, 2.11, 2.12).
#' @template args
#' @template key
#' @details By default the function drops the help and success slots. It returns
#' only the result slot. If you want raw json, request `as = 'json'`.
#' Then you parse the result yourself to get the help slot.
#' @examples \dontrun{
#' res <- group_list()
#'
#' # via a group name/id
#' group_show(res[[1]]$name)
#'
#' # or via an object of class ckan_group
#' group_show(res[[1]])
#'
#' # return different data formats
#' group_show(res[[1]]$name, as = "json")
#' group_show(res[[1]]$name, as = "table")
#' }
group_show <- function(
  id, include_datasets = TRUE, include_users = TRUE,
  url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_group(id, url = url)
  args <- cc(list(
    id = id$id,
    include_datasets = as_log(include_datasets),
    include_users = as_log(include_users)
  ))
  res <- ckan_GET(url, "group_show", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_group"),
    table = jsd(res)
  )
}
