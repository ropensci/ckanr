#' Update an organization.
#'
#' This function updates all organization metadata fields. You must be
#' authorized to edit the organization. Update methods may delete parameters
#' not explicitly provided: if you want to edit only specific attributes,
#' use [organization_patch()] instead. For the full list of accepted fields,
#' see [organization_create()] and
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.organization_update>.
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character or `ckan_organization`) The name or id of the
#' organization to update, or a `ckan_organization` object.
#' @template args
#' @template key
#' @return The updated organization as a `ckan_organization` object.
#' With `as = "table"`, a data.frame; with `as = "json"`, the raw JSON
#' response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.organization_update
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # First, create an organization
#' org <- organization_create("water-bears2")
#' organization_show(org)
#'
#' # Make some changes
#' x <- list(description = "An organization about water bears")
#'
#' # Then update the organization
#' organization_update(x, id = org)
#' }
organization_update <- function(
  x, id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  id <- as.ckan_organization(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url,
    method = "organization_update",
    body = tojun(x, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_organization"),
    table = jsd(res)
  )
}
