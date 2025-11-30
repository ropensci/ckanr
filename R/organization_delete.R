#' Delete an organization
#'
#' @export
#'
#' @param id (character) name or id of the organization
#' @template key
#' @template args
#' @return an empty list on success
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create an organization
#' (res <- organization_create("foobar",
#'   title = "Foo bars",
#'   description = "love foo bars"
#' ))
#'
#' # delete the organization just created
#' res$id
#' organization_delete(id = res$id)
#' }
organization_delete <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  org_id <- NULL
  if (is.ckan_organization(id)) {
    org_id <- id$id
  } else if (is.list(id) && !is.null(id$id)) {
    org_id <- id$id
  } else if (is.character(id) && length(id) == 1) {
    org_id <- id
  } else {
    stop("id must be a string or ckan_organization", call. = FALSE)
  }

  res <- ckan_POST(url, "organization_delete", list(id = org_id),
    key = key,
    opts = list(...)
  )
  parsed <- jsonlite::fromJSON(res)
  switch(as,
    json = res,
    list = parsed$success,
    table = parsed$success
  )
}
