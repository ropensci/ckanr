#' Return a a user's follower count
#'
#' @export
#' @param id (character) User identifier.
#' @template args
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # list package activity
#' user_follower_count('sckottie')
#'
#' # input a ckan_user object
#' (x <- user_show('sckottie'))
#' user_follower_count(x)
#'
#' # output different data formats
#' user_follower_count(x, as = "table")
#' user_follower_count(x, as = "json")
#' }
user_follower_count <- function(id, url = get_default_url(), as = "list", ...) {
  id <- as.ckan_user(id, url = url)
  res <- ckan_POST(url, 'user_follower_count', body = list(id = id$id), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
