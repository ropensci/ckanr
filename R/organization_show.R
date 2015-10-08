#' Show an organization
#'
#' @export
#'
#' @param id (character) Organization id or name.
#' @param include_datasets (logical). Whether to include a list of the
#'   organization datasets
#' @template args
#' @template key
#' @details By default the help and success slots are dropped, and only the
#'   result slot is returned. You can request raw json with \code{as = 'json'}
#'   then parse yourself to get the help slot.
#' @examples \dontrun{
#' res <- organization_create("stuffthings")
#' organization_show(res$id)
#' }
organization_show <- function(id, include_datasets = FALSE, url = get_default_url(),
                              key = get_default_key(), as = 'list', ...) {
  body <- cc(list(id = id, include_datasets = include_datasets))
  res <- ckan_POST(url, 'organization_show',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
