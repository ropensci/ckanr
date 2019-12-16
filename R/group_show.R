#' Show a package
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param include_datasets (logical) Include a list of the group's datasets.
#' Default: `TRUE`
#' @template args
#' @template key
#' @details By default the help and success slots are dropped, and only the
#' result slot is returned. You can request raw json with `as = 'json'`
#' then parse yourself to get the help slot.
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
#' group_show(res[[1]]$name, as = 'json')
#' group_show(res[[1]]$name, as = 'table')
#' }
group_show <- function(id, include_datasets = TRUE, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_group(id, url = url)
  args <- cc(list(id = id$id, include_datasets = as_log(include_datasets)))
  res <- ckan_GET(url, 'group_show', args, key = key, opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_group"), table = jsd(res))
}
