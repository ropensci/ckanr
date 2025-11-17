#' Activity stream helpers
#'
#' These helpers wrap CKAN's `ckanext.activity` endpoints. They require the
#' `activity` core plugin to be enabled on the target CKAN instance.
#'
#' @name activity_helpers
#' @template paging
#' @template args
#' @template key
#' @param id (character) Identifier of the target object (group, organization,
#'   activity, etc.).
#' @param include_hidden_activity (logical) If `TRUE`, include private activity
#'   entries (requires sysadmin).
#' @param object_type (character) Domain object affected by the activity, e.g.,
#'   "package", "resource", or a plugin-defined type.
#' @param diff_type (character) Diff format returned by `activity_diff()`,
#'   typically "unified".
#' @param user_id (character) User identifier associated with a custom
#'   `activity_create()` entry.
#' @param object_id (character) Target object identifier for
#'   `activity_create()`.
#' @param activity_type (character) Activity type string to emit via
#'   `activity_create()`.
#' @param data (list|character) Optional structured payload describing the
#'   activity body. Lists are JSON-encoded automatically.
NULL

#' @rdname activity_helpers
#' @export
group_activity_list <- function(id, offset = 0, limit = 31,
  include_hidden_activity = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  id <- as.ckan_group(id, url = url, key = key)
  args <- cc(list(
    id = id$id,
    offset = offset,
    limit = limit,
    include_hidden_activity = as_log(include_hidden_activity)
  ))
  res <- ckan_GET(url, "group_activity_list", args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
organization_activity_list <- function(id, offset = 0, limit = 31,
  include_hidden_activity = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  id <- as.ckan_organization(id, url = url, key = key)
  args <- cc(list(
    id = id$id,
    offset = offset,
    limit = limit,
    include_hidden_activity = as_log(include_hidden_activity)
  ))
  res <- ckan_GET(url, "organization_activity_list", args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
recently_changed_packages_activity_list <- function(offset = 0, limit = 31,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  ver <- floor(ckan_version(url)$version_num)
  if (ver > 29 && ver < 212) {
    stop("recently_changed_packages_activity_list() is not supported on CKAN 2.10-2.11", call. = FALSE)
  }
  args <- cc(list(offset = offset, limit = limit))
  res <- ckan_GET(url, "recently_changed_packages_activity_list", args,
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
dashboard_new_activities_count <- function(url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res <- ckan_GET(url, "dashboard_new_activities_count", list(), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
dashboard_mark_activities_old <- function(url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  res <- ckan_POST(url, "dashboard_mark_activities_old", body = list(),
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
activity_show <- function(id, url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  res <- ckan_GET(url, "activity_show", list(id = id), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
activity_data_show <- function(id, object_type, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  args <- cc(list(id = id, object_type = object_type))
  res <- ckan_GET(url, "activity_data_show", args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
activity_diff <- function(id, object_type, diff_type = "unified",
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  args <- cc(list(id = id, object_type = object_type, diff_type = diff_type))
  res <- ckan_GET(url, "activity_diff", args, key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
activity_create <- function(user_id, object_id, activity_type, data = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  if (!is.null(data)) {
    if (is.list(data)) {
      data <- tojun(data, TRUE)
    } else if (!is.character(data) || length(data) != 1) {
      stop("`data` must be a named list or JSON string", call. = FALSE)
    }
  }

  body <- cc(list(
    user_id = user_id,
    object_id = object_id,
    activity_type = activity_type,
    data = data
  ))
  res <- ckan_POST(url, "activity_create", body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname activity_helpers
#' @export
send_email_notifications <- function(url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  notif_enabled <- activity_email_notifications_enabled(url, key)
  if (identical(notif_enabled, FALSE)) {
    stop(
      "Activity email notifications are disabled on this CKAN instance",
      call. = FALSE
    )
  }
  res <- ckan_POST(url, "send_email_notifications", body = list(),
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

activity_email_notifications_enabled <- local({
  cache <- new.env(parent = emptyenv())
  truthy <- c("true", "1", "yes", "on")
  falsy <- c("false", "0", "no", "off", "")
  function(url = get_default_url(), key = get_default_key()) {
    cache_key <- notrail(url)
    cached <- get0(cache_key, envir = cache, inherits = FALSE)
    if (!is.null(cached)) {
      return(cached)
    }
    option_value <- tryCatch(
      config_option_show(
        "ckan.activity_streams_email_notifications",
        url = url,
        key = key
      ),
      error = function(e) e
    )
    status <- NA
    if (!inherits(option_value, "error") && !is.null(option_value)) {
      value <- option_value
      if (is.list(value)) {
        if (!is.null(value$value)) {
          value <- value$value
        } else if (!is.null(value$result) && !is.null(value$result$value)) {
          value <- value$result$value
        }
      }
      if (is.logical(value) && length(value) == 1) {
        status <- value
      } else if (is.character(value) && length(value) == 1) {
        val <- tolower(trimws(value))
        if (val %in% truthy) {
          status <- TRUE
        } else if (val %in% falsy) {
          status <- FALSE
        }
      }
    }
    assign(cache_key, status, envir = cache)
    status
  }
})
