#' Return a list of the site's user accounts.
#'
#' @export
#' @param id (character) Package identifier.
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 31)
#' @template args
#' @examples \donttest{
#' package_activity_list("34d60b13-1fd5-430e-b0ec-c8bc7f4841cf")
#' package_activity_list("34d60b13-1fd5-430e-b0ec-c8bc7f4841cf", as="table")
#' package_activity_list("34d60b13-1fd5-430e-b0ec-c8bc7f4841cf", as="json")
#' }
package_activity_list <- function(id, offset = 0, limit = 31, url = 'http://data.techno-science.ca',
                                  as="list", ...)
{
  body <- cc(list(id=id, offset = offset, limit = limit))
  res <- ckan_POST(url, 'package_activity_list', body=body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
