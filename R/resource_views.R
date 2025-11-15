#' Resource view management
#'
#' Helpers that wrap CKAN's `resource_view_*` endpoints.
#'
#' @name resource_views
NULL

#' List resource views for a resource
#'
#' @param id (character or `ckan_resource`) Resource identifier.
#' @template args
#' @template key
#' @export
#' @examples \dontrun{
#' pkg <- package_show("sample-dataset")
#' resource_view_list(pkg$resources[[1]]$id)
#' }
resource_view_list <- function(id, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res <- as.ckan_resource(id, url = url, key = key)
  out <- ckan_GET(url, "resource_view_list", list(id = res$id), key = key,
    opts = list(...))
  switch(as,
    json = out,
    list = lapply(jsl(out), as_ck, "ckan_resource_view"),
    table = jsd(out)
  )
}

#' Show a resource view
#'
#' @param id (character or `ckan_resource_view`) View identifier.
#' @template args
#' @template key
#' @export
resource_view_show <- function(id, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  if (inherits(id, "ckan_resource_view")) id <- id$id
  out <- ckan_GET(url, "resource_view_show", list(id = id), key = key,
    opts = list(...))
  switch(as,
    json = out,
    list = as_ck(jsl(out), "ckan_resource_view"),
    table = jsd(out)
  )
}

#' Create a resource view
#'
#' @param resource (character or `ckan_resource`) Parent resource identifier.
#' @param view_type (character) Plugin type registered on the CKAN site.
#' @param title (character) Title assigned to the view.
#' @param description (character) Optional description.
#' @param config (list) Arbitrary configuration list passed to the plugin.
#' @param filter_fields,filter_values Optional filter parameters for filterable views.
#' @template args
#' @template key
#' @export
resource_view_create <- function(resource, view_type, title,
  description = NULL, config = NULL, filter_fields = NULL,
  filter_values = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res <- as.ckan_resource(resource, url = url, key = key)
  body <- cc(list(
    resource_id = res$id,
    view_type = view_type,
    title = title,
    description = description,
    config = config,
    filter_fields = filter_fields,
    filter_values = filter_values
  ))
  out <- ckan_POST(url, "resource_view_create", body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  switch(as,
    json = out,
    list = as_ck(jsl(out), "ckan_resource_view"),
    table = jsd(out)
  )
}

#' Update an existing resource view
#'
#' @param id (character or `ckan_resource_view`) View identifier.
#' @inheritParams resource_view_create
#' @template args
#' @template key
#' @export
resource_view_update <- function(id, resource = NULL, title = NULL,
  description = NULL, config = NULL, filter_fields = NULL,
  filter_values = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  view <- as.ckan_resource_view(id, url = url, key = key)
  body <- cc(list(
    id = view$id,
    resource_id = if (!is.null(resource)) as.ckan_resource(resource,
      url = url, key = key)$id else NULL,
    title = title,
    description = description,
    config = config,
    filter_fields = filter_fields,
    filter_values = filter_values
  ))
  out <- ckan_POST(url, "resource_view_update", body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  switch(as,
    json = out,
    list = as_ck(jsl(out), "ckan_resource_view"),
    table = jsd(out)
  )
}

#' Reorder resource views
#'
#' @param id (character or `ckan_resource`) Resource identifier.
#' @param order (character vector) View IDs in the desired order.
#' @template args
#' @template key
#' @export
resource_view_reorder <- function(id, order, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res <- as.ckan_resource(id, url = url, key = key)
  body <- list(id = res$id, order = as.list(order))
  out <- ckan_POST(url, "resource_view_reorder", body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  switch(as,
    json = out,
    list = jsl(out),
    table = jsd(out)
  )
}

#' Delete a resource view
#'
#' @param id (character or `ckan_resource_view`) View identifier.
#' @template args_noas
#' @template key
#' @export
resource_view_delete <- function(id, url = get_default_url(),
  key = get_default_key(), ...) {

  view <- as.ckan_resource_view(id, url = url, key = key)
  out <- ckan_POST(url, "resource_view_delete", body = list(id = view$id),
    key = key, opts = list(...))
  jsonlite::fromJSON(out)$result
}

#' Clear resource views
#'
#' @param view_types (character vector) Optional subset of view types to delete.
#'   When `NULL`, all views are removed.
#' @template args_noas
#' @template key
#' @export
resource_view_clear <- function(view_types = NULL, url = get_default_url(),
  key = get_default_key(), ...) {

  body <- cc(list(view_types = as.list(view_types)))
  out <- ckan_POST(url, "resource_view_clear", body = tojun(body, TRUE),
    key = key, headers = ctj(), encode = "json", opts = list(...))
  jsonlite::fromJSON(out)$success
}

#' Create default views for a single resource
#'
#' @param resource (character or `ckan_resource`) Resource identifier or object.
#' @param package (optional) Dataset identifier or `ckan_package` object.
#' @param create_datastore_views (logical) When `TRUE`, only create views that
#'   require DataStore-backed resources (used when DataPusher finishes ingesting data).
#' @template args
#' @template key
#' @export
resource_create_default_resource_views <- function(resource, package = NULL,
  create_datastore_views = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res_obj <- unclass(as.ckan_resource(resource, url = url, key = key))
  pkg_obj <- if (is.null(package)) NULL else unclass(
    as.ckan_package(package, url = url, key = key)
  )
  body <- cc(list(
    resource = res_obj,
    package = pkg_obj,
    create_datastore_views = create_datastore_views
  ))
  out <- ckan_POST(url, "resource_create_default_resource_views",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  switch(as,
    json = out,
    list = jsl(out),
    table = jsd(out)
  )
}

#' Create default views for all resources in a dataset
#'
#' @param package (character or `ckan_package`) Dataset identifier.
#' @inheritParams resource_create_default_resource_views
#' @template args
#' @template key
#' @export
package_create_default_resource_views <- function(package,
  create_datastore_views = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  pkg_obj <- unclass(as.ckan_package(package, url = url, key = key))
  body <- cc(list(
    package = pkg_obj,
    create_datastore_views = create_datastore_views
  ))
  out <- ckan_POST(url, "package_create_default_resource_views",
    body = tojun(body, TRUE), key = key, headers = ctj(), encode = "json",
    opts = list(...))
  switch(as,
    json = out,
    list = jsl(out),
    table = jsd(out)
  )
}
