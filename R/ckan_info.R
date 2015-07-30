#' Get information on a CKAN server
#'
#' @export
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}. (required)
#' @param ... Curl args passed on to \code{\link[httr]{GET}} (optional)
#' @examples \dontrun{
#' ckan_info()
#' ckan_info(servers()[5])
#' }
ckan_info <- function(url = get_default_url(), ...) {
  res <- httr::GET(file.path(url, "api/util/status"))
  stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text"))
}
