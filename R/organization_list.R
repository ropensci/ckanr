#' List organization
#'
#' @export
#'
#' @param order_by (character, only the first element is used).
#' The field to sort the list by, must be \code{name} or \code{packages}.
#' @param decreasing (logical). Is the sort-order is decreasing or not.
#' @param organizations (character or NULL). A list of names of the
#' organizations to return. NULL returns all organizations.
#' @param all_fields (logical). Return the name or all fields of the object.
#' @param limit (numeric) The maximum number of organizations to return
#' (optional, default: 31)
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/")
#'
#' # list organizations
#' res <- organization_list()
#' res[1:2]
#'
#' # Different data formats
#' organization_list(as = 'json')
#' organization_list(as = 'table')
#' }
organization_list <- function(order_by = c("name", "package"),
  decreasing = FALSE, organizations = NULL, all_fields = TRUE,
  limit = 31, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  stopifnot(length(order_by) > 0)
  stopifnot(order_by[1] %in% c("name", "package"))
  args <- cc(list(sort = sprintf("%s %s", order_by[1],
                              ifelse(decreasing, "", "asc")),
               all_fields = ifelse(all_fields, "True", "False"),
               limit = limit,
               organizations = organizations))
  res <- ckan_GET(url, 'organization_list', args, key = key, ...)
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization),
    table = jsd(res))
}
