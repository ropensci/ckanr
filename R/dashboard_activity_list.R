#' Authorized user's dashboard activity stream
#'
#' @export
#'
#' @param limit (integer) The maximum number of activities to return (optional).
#' Default: 31
#' @param offset (integer) Where to start getting activity items from (optional).
#' Default: 0
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # get activity
#' (res <- dashboard_activity_list())
#' }
dashboard_activity_list <- function(limit = 31, offset = 0, key = get_default_key(),
  url = get_default_url(), as = 'list', ...) {

  body <- list(limit = limit, offset = offset)
  res <- ckan_POST(url, 'dashboard_activity_list', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
