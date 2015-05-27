#' Return a dataset (package's) revisions as a list of dictionaries.
#'
#' @export
#' @param id (character) Package identifier.
#' @template args
#' @examples \dontrun{
#' package_revision_list('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf')
#' package_revision_list('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as = "table")
#' package_revision_list('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as = "json")
#' }
package_revision_list <- function(id, url = get_default_url(), as = "list", ...) {
  res <- ckan_POST(url, 'package_revision_list', body = list(id = id), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
