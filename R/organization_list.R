#' List organization
#'
#' @export
#'
#' @param order_by (character, only the first element is used).
#'    The field to sort the list by, must be \code{name} or \code{packages}.
#' @param decreasing (logical). Is the sort-order is decreasing or not.
#' @param organizations (character or NULL). A list of names of the
#'    organizations to return. NULL returns all organizations.
#' @param all_fields (logical). Return the name or all fields of the object.
#' @template args
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/")
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
                              decreasing = FALSE, organizations = NULL,
                              all_fields = TRUE,
                              url = get_default_url(), as = 'list', ...) {
  stopifnot(length(order_by) > 0)
  stopifnot(order_by[1] %in% c("name", "package"))
  body <- cc(list(sort = sprintf("%s %s", order_by[1],
                              ifelse(decreasing, "", "asc")),
               all_fields = ifelse(all_fields, "True", "False"),
               organizations = organizations))
  res <- ckan_POST(url, method = 'organization_list', body = body, ...)
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization), table = jsd(res))
}
