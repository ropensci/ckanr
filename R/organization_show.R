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
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' res <- organization_create("stuffthings2")
#' organization_show(res$id)
#' }
organization_show <- function(id, include_datasets = FALSE, url = get_default_url(),
                              key = get_default_key(), as = 'list', ...) {
  id <- as.ckan_organization(id, url = url)
  body <- cc(list(id = id$id, include_datasets = include_datasets))
  res <- ckan_POST(url, 'organization_show',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_organization"), table = jsd(res))
}
