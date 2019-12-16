#' Return a list of the site's user accounts.
#'
#' @export
#' @param q (character) Restrict the users returned to those whose names
#' contain a string
#' @param order_by (character) Which field to sort the list by
#' (optional, default: 'name')
#' @template args
#' @template key
#' @examples \dontrun{
#' # all users
#' user_list()
#'
#' # search for a user
#' user_list(q = "j")
#'
#' # different data formats
#' user_list(q = "j", as = "table")
#' user_list(q = "j", as = "json")
#' }
user_list <- function(q = NULL, order_by = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  args <- cc(list(q = q, order_by = order_by))
  res <- ckan_GET(url, 'user_list', query = args, key = key, opts = list(...))
  switch(as, json = res, list = lapply(jsl(res), as.ckan_user),
    table = jsd(res))
}
