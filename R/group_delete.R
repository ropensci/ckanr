#' Delete a group
#'
#' @export
#' @param id (character) The id of the group. Required.
#' @template key
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.
#' @param ... Curl args passed on to \code{\link[httr]{POST}} (optional)
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a group
#' (res <- group_create("lions", description="A group about lions"))
#'
#' # show the group
#' group_show(res$id)
#'
#' # delete the group
#' group_delete(res)
#' ## or with it's id
#' # group_delete(res$id)
#' }
group_delete <- function(id, key = get_default_key(), url = get_default_url(), ...) {
  id <- as.ckan_group(id, url = url)
  tmp <- ckan_POST(url, 'group_delete', body = list(id = id$id), key = key, ...)
  jsonlite::fromJSON(tmp)$success
}
