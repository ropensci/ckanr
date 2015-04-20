#' Show an organization
#'
#' @export
#'
#' @param id (character) Organization id or name.
#' @param include_datasets (logical). Whether to include a list of the organization datasets
#' @template args
#' @details By default the help and success slots are dropped, and only the result
#' slot is returned. You can request raw json with \code{as='json'} then parse yourself
#' to get the help slot.
#' @examples \donttest{
#' }
organization_show <- function(id, include_datasets = FALSE,
  url = get_ckanr_url(), as='list', ...)
{
  body <- cc(list(id = id),
             include_datasets = ifelse(include_datasets, "True", "False"))
  res <- ckan_POST(url, 'organization_show', body = cc(body), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
