#' Dataset maintenance helpers
#'
#' The file covers extra CKAN 2.11 dataset endpoints for bulk edits and destructive actions.
#'
#' @name package_dataset_extras
NULL

#' Revise a dataset using match/filter/update semantics
#'
#' @param match (list) Key/value pairs that identify the dataset to revise. Unless you use flattened keys,
#' this parameter is required.
#' @param filter (character or list) Patterns that describe fields to remove before the update runs.
#' @param update (list) Values to set after filtering. The values support flattened keys.
#' @param include (character or list) Optional patterns that delimit which fields the response returns.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' package_revise(
#'   match = list(name = "source-dataset"),
#'   update = list(notes = "New description")
#' )
#' }
package_revise <- function(
  match = NULL, filter = NULL, update = NULL,
  include = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  body <- cc(list(
    match = match, filter = filter, update = update,
    include = include
  ))
  res <- ckan_POST(url, "package_revise",
    body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Reorder resources for a dataset
#'
#' @param id (character or `ckan_package`) Dataset identifier.
#' @param order (character vector) Resource IDs in the desired order.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' pkg <- package_show("my-dataset")
#' package_resource_reorder(pkg,
#'   order = rev(vapply(pkg$resources, `[[`, "id", FUN.VALUE = character(1)))
#' )
#' }
package_resource_reorder <- function(
  id, order,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(id = pkg$id, order = as.list(order))
  res <- ckan_POST(url, "package_resource_reorder",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Move a dataset to another organization
#'
#' On CKAN 2.12 `package_owner_org_update` may report success without moving
#' the dataset; when the verification shows the dataset is still owned by
#' the previous organization, the function falls back to
#' [package_patch()] with `owner_org`, which moves the dataset reliably on
#' all supported versions.
#'
#' @param id (character or `ckan_package`) Dataset identifier.
#' @param organization_id (character or `ckan_organization`) Owning organization identifier.
#' @template args_noas
#' @template key
#' @export
#' @examples \dontrun{
#' package_owner_org_update("dataset-id", organization_id = "target-org")
#' }
package_owner_org_update <- function(
  id, organization_id,
  url = get_default_url(), key = get_default_key(), ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  org <- resolve_group_or_org_id(organization_id)
  body <- list(id = pkg$id, organization_id = org)
  res <- ckan_POST(url, "package_owner_org_update",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...)
  )
  ok <- jsonlite::fromJSON(res)$success
  if (!isTRUE(ok)) {
    return(ok)
  }
  # CKAN 2.12 may report success without moving the dataset (verified
  # against 2.12.0); on 2.9-2.11 the native action is sufficient, so only
  # verify outside that range (or when the version is unknown).
  ver <- try(ckan_version(url)$version_num, silent = TRUE)
  if (!inherits(ver, "try-error") && !is.na(ver) && ver >= 29 && ver < 212) {
    return(ok)
  }
  target_id <- tryCatch(
    as.ckan_organization(organization_id, url = url, key = key)$id,
    error = function(e) NULL
  )
  if (is.null(target_id)) {
    # Cannot resolve the target: report the native result; the caller can
    # verify via package_show().
    return(ok)
  }
  current_id <- package_owner_org_id(pkg$id, url = url, key = key)
  if (is.null(current_id) || identical(current_id, target_id)) {
    return(ok)
  }
  patched <- tryCatch(
    package_patch(list(id = pkg$id, owner_org = target_id),
      url = url, key = key),
    error = function(e) e
  )
  if (inherits(patched, "error")) {
    stop(conditionMessage(patched), call. = FALSE)
  }
  verified_id <- package_owner_org_id(pkg$id, url = url, key = key)
  identical(verified_id, target_id)
}

package_owner_org_id <- function(pkg_id, url, key) {
  moved <- tryCatch(
    package_show(pkg_id, url = url, key = key),
    error = function(e) NULL
  )
  if (!is.list(moved)) {
    return(NULL)
  }
  if (!is.null(moved$owner_org) && nzchar(as.character(moved$owner_org)[1])) {
    return(as.character(moved$owner_org)[1])
  }
  org <- moved$organization
  if (is.list(org) && !is.null(org$id)) {
    return(as.character(org$id)[1])
  }
  NULL
}

#' Permanently purge a dataset
#'
#' @param id (character or `ckan_package`) Dataset identifier.
#' @template args_noas
#' @template key
#' @export
#' @examples \dontrun{
#' dataset_purge("dataset-id")
#' }
dataset_purge <- function(
  id, url = get_default_url(), key = get_default_key(),
  ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  res <- ckan_POST(url, "dataset_purge",
    body = tojun(list(id = pkg$id), TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...)
  )
  jsonlite::fromJSON(res)$success
}
