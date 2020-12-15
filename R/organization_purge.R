#' Purge an organization
#'
#' IMPORTANT: You must be a sysadmin to purge an organization. Once an
#' organization is purged, it is permanently removed from the system.
#'
#' @export
#'
#' @param id (character) name or id of the organization
#' @template key
#' @template args
#' @return an empty list on success
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key=getOption("ckan_demo_key"))
#'
#' # create an organization
#' (res <- organization_create("foobar", title = "Foo bars",
#'   description = "love foo bars"))
#'
#' # delete the organization just created
#' res$id
#' organization_delete(id = res$id)
#'
#' # purge the organization just deleted
#' res$id
#' organization_purge(id = res$id)
#' }
organization_purge <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_POST(url, 'organization_purge', list(id = id), key = key, ...)
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization),
    table = jsd(res))
}
