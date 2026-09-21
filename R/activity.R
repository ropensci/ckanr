#' Activity stream helpers
#'
#' These helpers wrap CKAN's `ckanext.activity` endpoints. The target CKAN
#' instance must enable the `activity` core plugin.
#'
#' @name activity_helpers
#' @template paging
#' @template args
#' @template key
#' @param id (character) Identifier of the target object (group, organization,
#'   activity, etc.).
#' @param include_hidden_activity (logical) If `TRUE`, include private activity
#'   entries. You must have sysadmin rights.
#' @param object_type (character) Domain object that the activity affects, for
#'   example "package", "resource", or a plugin-defined type.
#' @param diff_type (character) Diff format that `activity_diff()` returns,
#'   typically "unified".
#' @param user_id (character) User identifier associated with a custom
#'   `activity_create()` entry.
#' @param object_id (character) Target object identifier for
#'   `activity_create()`.
#' @param activity_type (character) Activity type string to emit via
#'   `activity_create()`.
#' @param data (list|character) Optional structured payload that describes the
#'   activity body. The function encodes lists as JSON automatically.
#' @param start_date (character) Start of the deletion range (ISO 8601,
#'   e.g. "YYYY-MM-DD" or "YYYY-MM-DDTHH:mm") for `activity_delete()`.
#' @param end_date (character) End of the deletion range (ISO 8601) for
#'   `activity_delete()`. Provide both `start_date` and `end_date` to delete
#'   a date range, or use `offset_days` instead.
#' @param offset_days (numeric) Delete activities older than this many days
#'   for `activity_delete()`.
#' @param keep (numeric) Optional. When set, keep this many most recent
#'   activities per item and delete only older ones in the range.
#' @param batch_size (numeric) Optional batch size for deletes on large
#'   tables (e.g. millions of rows) to avoid timeouts and long locks.
NULL

#' @rdname activity_helpers
#' @export
group_activity_list <- function(
  id, offset = 0, limit = 31,
  include_hidden_activity = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_group(id, url = url, key = key)
  args <- cc(list(
    id = id$id,
    offset = offset,
    limit = limit,
    include_hidden_activity = as_log(include_hidden_activity)
  ))
  res <- ckan_GET(url, "group_activity_list", args,
    key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
organization_activity_list <- function(
  id, offset = 0, limit = 31,
  include_hidden_activity = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_organization(id, url = url, key = key)
  args <- cc(list(
    id = id$id,
    offset = offset,
    limit = limit,
    include_hidden_activity = as_log(include_hidden_activity)
  ))
  res <- ckan_GET(url, "organization_activity_list", args,
    key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
recently_changed_packages_activity_list <- function(
  offset = 0, limit = 31,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  args <- cc(list(offset = offset, limit = limit))
  res <- ckan_GET(url, "recently_changed_packages_activity_list", args,
    key = key, opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
dashboard_new_activities_count <- function(
  url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  res <- ckan_GET(url, "dashboard_new_activities_count", list(),
    key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
dashboard_mark_activities_old <- function(
  url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  res <- ckan_POST(url, "dashboard_mark_activities_old",
    body = list(),
    key = key, opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
activity_show <- function(
  id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  res <- ckan_GET(url, "activity_show", list(id = id),
    key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
activity_data_show <- function(
  id, object_type, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(id = id, object_type = object_type))
  res <- ckan_GET(url, "activity_data_show", args,
    key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
activity_diff <- function(
  id, object_type, diff_type = "unified",
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  args <- cc(list(id = id, object_type = object_type, diff_type = diff_type))
  res <- ckan_GET(url, "activity_diff", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
activity_create <- function(
  user_id, object_id, activity_type, data = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
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
  res <- ckan_POST(url, "activity_create",
    body = body, key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname activity_helpers
#' @export
send_email_notifications <- function(
  url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  notif_enabled <- activity_email_notifications_enabled(url, key)
  if (identical(notif_enabled, FALSE)) {
    stop(
      "Activity email notifications are disabled on this CKAN instance",
      call. = FALSE
    )
  }
  res <- ckan_POST(url, "send_email_notifications",
    body = list(),
    key = key, opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Activity purge helpers (CKAN 2.12+)
#'
#' These helpers wrap the CKAN 2.12 activity purge feature
#' (<https://github.com/ckan/ckan/pull/8189>). You must have sysadmin
#' rights and the target instance must enable the `activity` plugin with
#' CKAN 2.12 or later. Each wrapper calls `ensure_action_available()` so
#' it fails clearly on older instances.
#'
#' @name activity_purge
#' @template args
#' @template key
#' @param id (character) Activity identifier to delete via
#'   `activity_delete()`. Alternatively provide `start_date` + `end_date`
#'   or `offset_days`.
#' @param start_date (character) Start of the deletion range (ISO 8601).
#' @param end_date (character) End of the deletion range (ISO 8601).
#' @param offset_days (numeric) Delete activities older than this many days.
#' @param keep (numeric) Optional. Keep this many most recent activities per
#'   item; delete only older ones in the range.
#' @param batch_size (numeric) Optional batch size for large tables.
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#' activity_delete_counts()
#' activity_delete(offset_days = 365)
#' }
NULL

#' @rdname activity_purge
#' @export
activity_delete <- function(
  id = NULL, start_date = NULL, end_date = NULL, offset_days = NULL,
  keep = NULL, batch_size = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("activity_delete", url = url, key = key)
  if (is.null(id) && is.null(offset_days) &&
      (is.null(start_date) || is.null(end_date))) {
    stop(
      "Provide `id`, `offset_days`, or both `start_date` and `end_date`",
      call. = FALSE
    )
  }
  body <- cc(list(
    id = id, start_date = start_date, end_date = end_date,
    offset_days = offset_days, keep = keep, batch_size = batch_size
  ))
  res <- ckan_POST(url, "activity_delete",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(res, as)
}

#' @rdname activity_purge
#' @export
activity_delete_all <- function(
  batch_size = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("activity_delete_all", url = url, key = key)
  body <- cc(list(batch_size = batch_size))
  res <- ckan_POST(url, "activity_delete_all",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(res, as)
}

#' @rdname activity_purge
#' @export
activity_delete_counts <- function(
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("activity_delete_counts", url = url, key = key)
  res <- ckan_POST(url, "activity_delete_counts",
    body = list(), key = key, opts = list(...)
  )
  parse_ckan_response(res, as)
}

activity_email_notifications_enabled <- local({
  cache <- new.env(parent = emptyenv())
  truthy <- c("true", "1", "yes", "on")
  falsy <- c("false", "0", "no", "off", "")
  function(url = get_default_url(), key = get_default_key()) {
    auth_tag <- if (is.null(key) || length(key) == 0L) "nokey" else "keyed"
    cache_key <- paste(notrail(url), auth_tag, sep = "|")
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
    if (is.na(status)) {
      # Unknown/transient (e.g. network error): do not cache so a temporary
      # outage cannot permanently disable notifications for the session.
      return(status)
    }
    assign(cache_key, status, envir = cache)
    status
  }
})
