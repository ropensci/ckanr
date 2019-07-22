#' Delete an organization
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
#' }
organization_delete <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_POST(url, 'organization_delete', list(id = id), key = key, ...)
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization),
    table = jsd(res))
}
