#' Return a list of a user's activities
#'
#' @export
#' @param id (character) User identifier.
#' @template paging
#' @template args
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # list package activity
#' user_activity_list('sckottie')
#'
#' # input a ckan_user object
#' (x <- user_show('sckottie'))
#' user_activity_list(x)
#'
#' # output different data formats
#' user_activity_list(x, as = "table")
#' user_activity_list(x, as = "json")
#' }
user_activity_list <- function(id, offset = 0, limit = 31,
                                  url = get_default_url(), as = "list", ...) {
  id <- as.ckan_user(id, url = url)
  body <- cc(list(id = id$id, offset = offset, limit = limit))
  res <- ckan_POST(url, 'user_activity_list', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
