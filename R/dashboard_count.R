#' Number of new activities of an authorized user
#'
#' @export
#' @template args
#' @template key
#' @details Activities from the user herself are not counted by CKAN even
#' though they appear in the dashboard (users don't want to be notified about
#' things they did themselves).
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # count
#' dashboard_new_activities_count()
#' }
dashboard_count <- function(url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {
  dashboard_new_activities_count(url = url, key = key, as = as, ...)
}
