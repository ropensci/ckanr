#' Show an organization
#'
#' @export
#'
#' @param id (character) Organization id or name.
#' @param include_datasets (logical). Include a list of the
#' organization datasets.
#' @template args
#' @template key
#' @details By default the function drops the help and success slots. It returns
#' only the result slot. If you want raw json, request `as = 'json'`.
#' Then you parse the result yourself to get the help slot.
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' res <- organization_create("stuffthings2")
#' organization_show(res$id)
#' }
organization_show <- function(
  id, include_datasets = FALSE,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_organization(id, url = url)
  args <- cc(list(id = id$id, include_datasets = include_datasets))
  res <- ckan_GET(url, "organization_show", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_organization"),
    table = jsd(res)
  )
}
