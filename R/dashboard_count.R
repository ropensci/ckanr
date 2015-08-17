#' Number of new activities of an authorized user
#'
#' @export
#'
#' @template args
#' @template key
#' @details Important: Activities from the user herself are not counted by this
#' function even though they appear in the dashboard (users don't want to be notified
#' about things they did themselves).
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # count
#' dashboard_count()
#' }
dashboard_count <- function(key = get_default_key(), url = get_default_url(), as = 'list', ...) {
  res <- ckan_POST(url, 'dashboard_new_activities_count', body = list(), key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
