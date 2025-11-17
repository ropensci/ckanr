#' Activity stream helpers
#'
#' These helpers wrap CKAN's `ckanext.activity` endpoints. They require the
#' `activity` core plugin to be enabled on the target CKAN instance.
#'
#' @name activity_helpers
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

  res <- ckan_POST(url, "send_email_notifications", body = list(),
    key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
