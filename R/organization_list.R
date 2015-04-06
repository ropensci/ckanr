#' List organization
#'
#' @export
#'
#' @param order_by (character, only the first element is used).
#' The field to sort the list by, must be \code{name} or \code{packages}.
#' @param decreasing (logical). Is the sort-order is decreasing or not.
#' @param organizations NOT IMPLEMENTED YET
#' @param all_fields (logical). Return the name or all fields of the object.
#' @template args
#' @examples \donttest{
#' organization_list()
#' organization_list(as='json')
#' organization_list(as='table')
#' }
organization_list <- function(order_by = c("name", "package"),
                              decreasing = FALSE, organizations = NULL,
                              all_fields = TRUE, url = get_ckanr_url(),
                              as='list', ...)
{
  stopifnot(length(order_by) > 0)
  stopifnot(order_by[1] %in% c("name", "package"))
  body <- list(sort = sprintf("%s %s", order_by[1], ifelse(decreasing, "dsc", "asc")))
  if (all_fields) body[["all_fields"]] <- TRUE
  res <- ckan_POST(url, method='organization_list', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
