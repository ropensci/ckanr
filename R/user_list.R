#' Return a list of the site's user accounts.
#'
#' @export
#' @param q (character) Restrict the users returned to those whose names
#'    contain a string
#' @param order_by (character) Which field to sort the list by
#'    (optional, default: 'name')
#' @template args
#' @examples \dontrun{
#' user_list()
#' user_list(as = "table")
#' user_list(as = "json")
#' }
user_list <- function(q=NULL, order_by=NULL,
                      url = get_default_url(), as = "list", ...) {
  body <- cc(list(q = q, order_by = order_by))
  res <- ckan_POST(url, 'user_list', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
