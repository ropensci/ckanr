#' Return the list of licenses available for datasets on the site.
#'
#' @export
#' @param id (character) Package identifier.
#' @template args
#' @examples \dontrun{
#' license_list()
#' license_list(as = "table")
#' license_list(as = "json")
#' }
license_list <- function(id, url = get_default_url(), as = "list", ...) {
  res <- ckan_POST(url, 'license_list', ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
