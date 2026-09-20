#' Number of new activities of an authorized user
#'
#' @export
#' @template args
#' @template key
#' @details CKAN does not count activities from the user herself, but they
#' appear in the dashboard. Users do not want notices about things they did
#' themselves.
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # count
#' dashboard_new_activities_count()
#' }
dashboard_count <- function(
  url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  dashboard_new_activities_count(url = url, key = key, as = as, ...)
}
