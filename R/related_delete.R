#' Delete a related item.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.
#' @param ... Curl args passed on to \code{\link[httr]{POST}} (optional)
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package and a related item
#' res <- package_create("hello-venus2") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization")
#'
#' # show the related item
#' related_delete(res)
#' ## or with id itself:
#' ## related_delete(res$id)
#' }
related_delete <- function(id, key = get_default_key(), url = get_default_url(), ...) {
  id <- as.ckan_related(id, url = url)
  tmp <- ckan_POST(url, 'related_delete', body = list(id = id$id), key = key, ...)
  jsonlite::fromJSON(tmp)$success
}
