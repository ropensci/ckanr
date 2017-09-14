#' Delete an organization
#'
#' @export
#'
#' @param id (character) name or id of the organization
#' @template key
#' @template args
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/")
#'
#' # delete an organization
#' organization_delete(id = "someorgid")
#' }
organization_delete <- function(id, key = get_default_key(), url = get_default_url(),
                                as = 'list', ...) {
  res <- ckan_POST(url, 'organization_delete', list(id = id), key = key, ...)
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization), table = jsd(res))
}
