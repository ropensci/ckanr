#' Show a package
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param include_datasets (logical) Include a list of the group's datasets.
#'    Default: TRUE
#' @template args
#' @details By default the help and success slots are dropped, and only the
#'    result slot is returned. You can request raw json with \code{as = 'json'}
#'    then parse yourself to get the help slot.
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
group_show <- function(id, include_datasets = TRUE,
                       url = get_default_url(), as = 'list', ...) {
  id <- as.ckan_group(id, url = url)
  body <- cc(list(id = id$id, include_datasets = as_log(include_datasets)))
  res <- ckan_POST(url, 'group_show', body = body, ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_group"), table = jsd(res))
}
