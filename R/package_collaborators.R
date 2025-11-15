#' Package collaborator utilities
#'
#' @name package_collaborators
NULL

#' List collaborators for a dataset
#'
#' @param id (character or `ckan_package`) Dataset identifier or object.
#' @param capacity (character) Optional capacity filter (`"member"`, `"editor"`, `"admin"`).
#' @template key
#' @template args
#' @export
#' @examples \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_list("my-dataset")
#' }
package_collaborator_list <- function(id, capacity = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  args <- cc(list(id = pkg$id, capacity = capacity))
  res <- ckan_GET(url, "package_collaborator_list", query = args,
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' List packages a user collaborates on
#'
#' @param id (character or `ckan_user`) User identifier or object.
#' @param capacity (character) Optional capacity filter.
#' @template key
#' @template args
#' @export
#' @examples \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_list_for_user("sckottie")
#' }
package_collaborator_list_for_user <- function(id, capacity = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  user_id <- resolve_user_identifier(id)
  args <- cc(list(id = user_id, capacity = capacity))
  res <- ckan_GET(url, "package_collaborator_list_for_user", query = args,
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Create or update a dataset collaborator
#'
#' @param id (character or `ckan_package`) Dataset identifier or object.
#' @param user_id (character or `ckan_user`) User identifier or object.
#' @param capacity (character) Collaborator role (`"member"`, `"editor"`, `"admin"`).
#' @template key
#' @template args
#' @export
#' @examples \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_create("my-dataset", "new-user", capacity = "editor")
#' }
package_collaborator_create <- function(id, user_id, capacity,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(
    id = pkg$id,
    user_id = resolve_user_identifier(user_id),
    capacity = capacity
  )
  res <- ckan_POST(url, "package_collaborator_create", body = body,
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Delete a dataset collaborator
#'
#' @param id (character or `ckan_package`) Dataset identifier or object.
#' @param user_id (character or `ckan_user`) User identifier or object.
#' @template key
#' @template args
#' @export
#' @examples \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_delete("my-dataset", "new-user")
#' }
package_collaborator_delete <- function(id, user_id,
  url = get_default_url(), key = get_default_key(), ...) {

  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(
    id = pkg$id,
    user_id = resolve_user_identifier(user_id)
  )
  res <- ckan_POST(url, "package_collaborator_delete", body = body,
    key = key, opts = list(...))
  jsonlite::fromJSON(res)$success
}

resolve_user_identifier <- function(x) {
  if (is.ckan_user(x)) {
    return(if (!is.null(x$id)) x$id else x$name)
  }
  if (is.list(x) && !is.null(x$id)) {
    return(x$id)
  }
  x
}
