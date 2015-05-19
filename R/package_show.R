#' Show a package.
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @param use_default_schema (logical) Use default package schema instead of a custom
#' schema defined with an IDatasetForm plugin. Default: FALSE
#' @template args
#' @details By default the help and success slots are dropped, and only the result
#' slot is returned. You can request raw json with \code{as='json'} then parse yourself
#' to get the help slot.
#' @examples \dontrun{
#' package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf')
#' package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as='json')
#' package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as='table')
#' package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', TRUE)
#' }
package_show <- function(id, use_default_schema = FALSE, url = get_ckanr_url(),
                         key = NULL, as='list', ...) {
  body <- cc(list(id = id, use_default_schema = use_default_schema))
  res <- ckan_POST(url, 'package_show', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
