#' Show a user.
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param user_obj (user dictionary) The user dictionary of the user (optional)
#' @param include_datasets (logical) Include a list of datasets the user has
#' created. If it is the same user or a sysadmin requesting, it includes
#' datasets that are draft or private. (optional, default:False, limit:50)
#' @param include_num_followers (logical) Include the number of followers
#' the user has (optional, default:False)
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # show user
#' user_show('sckottie')
#'
#' # include datasets
#' user_show('sckottie', include_datasets = TRUE)
#'
#' # include datasets
#' user_show('sckottie', include_num_followers = TRUE)
#' }
user_show <- function(id, user_obj = NULL, include_datasets = FALSE,
  include_num_followers = FALSE, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_user(id, url = url)
  args <- cc(list(id = id$id, user_obj = user_obj,
    include_datasets = include_datasets,
    include_num_followers = include_num_followers))
  res <- ckan_GET(url, 'user_show', query = args, key = key, opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_user"), table = jsd(res))
}
