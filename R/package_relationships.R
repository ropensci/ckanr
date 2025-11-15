#' Package relationship helpers
#'
#' Utilities for managing dataset relationships via CKAN's `package_relationship_*` endpoints.
#'
#' @name package_relationships
NULL

#' List relationships for a dataset
#'
#' @param id (character or `ckan_package`) The dataset to inspect.
#' @param id2 (character or `ckan_package`) Optional secondary dataset identifier to scope results.
#' @param relationship_type (character) Filter on relationship type (see [package_relationship_create()]).
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_relationships_list("my-dataset")
#' }
package_relationships_list <- function(id, id2 = NULL, relationship_type = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  other <- if (is.null(id2)) NULL else as.ckan_package(id2, url = url, key = key)
  args <- cc(list(
    id = pkg$id,
    id2 = if (!is.null(other)) other$id else NULL,
    rel = relationship_type
  ))
  res <- ckan_GET(url, "package_relationships_list", query = args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Create a dataset relationship
#'
#' @param subject (character or `ckan_package`) Dataset acting as the subject in the relationship.
#' @param object (character or `ckan_package`) Dataset acting as the object in the relationship.
#' @param relationship_type (character) Relationship type (`"depends_on"`, `"derives_from"`, etc.).
#' @param comment (character) Optional note attached to the relationship.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' package_relationship_create("dataset-a", "dataset-b", relationship_type = "derives_from")
#' }
package_relationship_create <- function(subject, object, relationship_type,
  comment = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  subj <- as.ckan_package(subject, url = url, key = key)
  obj <- as.ckan_package(object, url = url, key = key)
  body <- cc(list(
    subject = subj$id,
    object = obj$id,
    type = relationship_type,
    comment = comment
  ))
  res <- ckan_POST(url, "package_relationship_create",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Update an existing dataset relationship
#'
#' @inheritParams package_relationship_create
#' @export
package_relationship_update <- function(subject, object, relationship_type,
  comment = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  subj <- as.ckan_package(subject, url = url, key = key)
  obj <- as.ckan_package(object, url = url, key = key)
  body <- cc(list(
    subject = subj$id,
    object = obj$id,
    type = relationship_type,
    comment = comment
  ))
  res <- ckan_POST(url, "package_relationship_update",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Delete a dataset relationship
#'
#' @inheritParams package_relationship_create
#' @export
package_relationship_delete <- function(subject, object, relationship_type,
  url = get_default_url(), key = get_default_key(), ...) {

  subj <- as.ckan_package(subject, url = url, key = key)
  obj <- as.ckan_package(object, url = url, key = key)
  body <- list(
    subject = subj$id,
    object = obj$id,
    type = relationship_type
  )
  res <- ckan_POST(url, "package_relationship_delete",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  jsonlite::fromJSON(res)$success
}
