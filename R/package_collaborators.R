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
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_list("my-dataset")
#' }
package_collaborator_list <- function(
  id, capacity = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  args <- cc(list(id = pkg$id, capacity = capacity))
  collaborator_request(
    endpoint = "package_collaborator_list",
    url = url,
    key = key,
    as = as,
    method = "GET",
    query = args,
    opts = list(...)
  )
}

#' List packages a user collaborates on
#'
#' @param id (character or `ckan_user`) User identifier or object.
#' @param capacity (character) Optional capacity filter.
#' @template key
#' @template args
#' @export
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_list_for_user("sckottie")
#' }
package_collaborator_list_for_user <- function(
  id, capacity = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  user_id <- resolve_user_identifier(id)
  args <- cc(list(id = user_id, capacity = capacity))
  collaborator_request(
    endpoint = "package_collaborator_list_for_user",
    url = url,
    key = key,
    as = as,
    method = "GET",
    query = args,
    opts = list(...)
  )
}

#' Create or update a dataset collaborator
#'
#' @param id (character or `ckan_package`) Dataset identifier or object.
#' @param user_id (character or `ckan_user`) User identifier or object.
#' @param capacity (character) Collaborator role (`"member"`, `"editor"`, `"admin"`).
#' @template key
#' @template args
#' @export
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_create("my-dataset", "new-user", capacity = "editor")
#' }
package_collaborator_create <- function(
  id, user_id, capacity,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(
    id = pkg$id,
    user_id = resolve_user_identifier(user_id),
    capacity = capacity
  )
  collaborator_request(
    endpoint = "package_collaborator_create",
    url = url,
    key = key,
    as = as,
    method = "POST",
    body = body,
    opts = list(...)
  )
}

#' Delete a dataset collaborator
#'
#' @param id (character or `ckan_package`) Dataset identifier or object.
#' @param user_id (character or `ckan_user`) User identifier or object.
#' @template key
#' @template args_noas
#' @export
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' package_collaborator_delete("my-dataset", "new-user")
#' }
package_collaborator_delete <- function(
  id, user_id,
  url = get_default_url(), key = get_default_key(), ...
) {
  pkg <- as.ckan_package(id, url = url, key = key)
  body <- list(
    id = pkg$id,
    user_id = resolve_user_identifier(user_id)
  )
  collaborator_request(
    endpoint = "package_collaborator_delete",
    url = url,
    key = key,
    method = "POST",
    body = body,
    success = TRUE,
    opts = list(...)
  )
}

# resolve_user_identifier is now defined in R/membership.R (shared utility).

collaborator_request <- function(endpoint, url, key, as = "list",
                                 method = c("GET", "POST"), query = NULL,
                                 body = NULL, success = FALSE,
                                 opts = list()) {
  method <- match.arg(method)
  resp <- if (method == "GET") {
    ckan_GET(url, endpoint, query = query, key = key, opts = opts)
  } else {
    ckan_POST(url, endpoint, body = body, key = key, opts = opts)
  }
  if (success) {
    return(jsonlite::fromJSON(resp)$success)
  }
  parse_ckan_response(resp, as)
}
