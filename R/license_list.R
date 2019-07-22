#' Return the list of licenses available for datasets on the site.
#'
#' @export
#' @param id (character) Package identifier.
#' @template args
#' @template key
#' @examples \dontrun{
#' license_list()
#' license_list(as = "table")
#' license_list(as = "json")
#' }
license_list <- function(id, url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  res <- ckan_GET(url, 'license_list', key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
