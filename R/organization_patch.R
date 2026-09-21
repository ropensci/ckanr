#' Patch an organization.
#'
#' This function partially updates an organization: it updates only the
#' provided parameters and leaves all other parameters unchanged (unlike
#' [organization_update()], which may delete parameters not explicitly
#' provided). See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.patch.organization_patch>
#' for the official API contract.
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character or `ckan_organization`) The id or name of the
#' organization to patch, or a `ckan_organization` object.
#' @template args
#' @template key
#' @return The patched organization as a `ckan_organization` object.
#' With `as = "table"`, a data.frame; with `as = "json"`, the raw JSON
#' response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.patch.organization_patch
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # Create an organization
#' (res <- organization_create("hello-my-org2"))
#'
#' # Get the organization
#' org <- organization_show(res$id)
#'
#' # Make some changes
#' x <- list(title = "!hello world!", description = "hello world org")
#' organization_patch(x, id = org)
#' }
organization_patch <- function(
  x, id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  id <- as.ckan_organization(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url,
    method = "organization_patch",
    body = tojun(x, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_organization"),
    table = jsd(res)
  )
}
