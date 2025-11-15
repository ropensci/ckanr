#' Dataset maintenance helpers
#'
#' Additional CKAN 2.11 dataset endpoints for bulk edits and destructive actions.
#'
#' @name package_dataset_extras
NULL

#' Revise a dataset using match/filter/update semantics
#'
#' @param match (list) Key/value pairs identifying the dataset to revise. Required unless using flattened keys.
#' @param filter (character or list) Patterns describing fields to remove before the update runs.
#' @param update (list) Values to set after filtering. Supports flattened keys.
#' @param include (character or list) Optional patterns delimiting which fields are returned in the response.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' package_revise(
#'   match = list(name = "source-dataset"),
#'   update = list(notes = "New description")
#' )
#' }
package_revise <- function(match = NULL, filter = NULL, update = NULL,
  include = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  body <- cc(list(match = match, filter = filter, update = update,
    include = include))
  res <- ckan_POST(url, "package_revise", body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
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
#' package_resource_reorder(pkg, order = rev(vapply(pkg$resources, `[[`, "id", FUN.VALUE = character(1))))
#' }
package_resource_reorder <- function(id, order,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(id = pkg$id, order = as.list(order))
  res <- ckan_POST(url, "package_resource_reorder",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Move a dataset to another organization
#'
#' @param id (character or `ckan_package`) Dataset identifier.
#' @param organization_id (character or `ckan_organization`) Owning organization identifier.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' package_owner_org_update("dataset-id", organization_id = "target-org")
#' }
package_owner_org_update <- function(id, organization_id,
  url = get_default_url(), key = get_default_key(), ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  org <- resolve_group_or_org_id(organization_id)
  body <- list(id = pkg$id, organization_id = org)
  res <- ckan_POST(url, "package_owner_org_update",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  jsonlite::fromJSON(res)$success
}

#' Permanently purge a dataset
#'
#' @param id (character or `ckan_package`) Dataset identifier.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' dataset_purge("dataset-id")
#' }
dataset_purge <- function(id, url = get_default_url(), key = get_default_key(),
  ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  res <- ckan_POST(url, "dataset_purge", body = tojun(list(id = pkg$id), TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  jsonlite::fromJSON(res)$success
}
