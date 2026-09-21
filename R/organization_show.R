#' Show an organization
#'
#' @export
#'
#' @param id (character) Organization id or name.
#' @param include_datasets (logical). Include a list of the
#' organization datasets.
#' @param include_users (logical) Include the organization's users. CKAN 2.12
#' changed the server default to `FALSE` regardless of the
#' `ckan.auth.public_user_details` setting
#' (<https://github.com/ckan/ckan/pull/9232>); ckanr defaults to `TRUE` to
#' preserve the historical behavior. The parameter is accepted on all
#' supported CKAN versions (2.9, 2.10, 2.11, 2.12).
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
  id, include_datasets = FALSE, include_users = TRUE,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_organization(id, url = url)
  args <- cc(list(
    id = id$id,
    include_datasets = as_log(include_datasets),
    include_users = as_log(include_users)
  ))
  res <- ckan_GET(url, "organization_show", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_organization"),
    table = jsd(res)
  )
}
