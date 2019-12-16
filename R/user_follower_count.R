#' Return a a user's follower count
#'
#' @export
#' @param id (character) User identifier.
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
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
user_follower_count <- function(id, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  id <- as.ckan_user(id, url = url)
  res <- ckan_GET(url, 'user_follower_count', query = list(id = id$id),
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
