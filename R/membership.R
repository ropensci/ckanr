#' Membership helpers
#'
#' Utilities for managing CKAN group and organization membership endpoints.
#'
#' @name membership
NULL

#' List members for a group or organization
#'
#' @param id (character, `ckan_group`, or `ckan_organization`) Identifier for the container.
#' @param object_type (character) Optional object type filter (`"user"`, `"package"`, etc.).
#' @param capacity (character) Optional capacity filter (`"member"`, `"editor"`, `"admin"`).
#' @template args
#' @template key
#' @export
#' @examples
#' # ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' # member_list("my-group", object_type = "user")
member_list <- function(id, object_type = NULL, capacity = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  group_id <- resolve_group_or_org_id(id)
  args <- cc(list(id = group_id, object_type = object_type, capacity = capacity))
  membership_request("member_list",
    url = url, key = key, as = as,
    method = "GET", query = args, opts = list(...)
  )
}

#' Create or update a membership via member_* endpoints
#'
#' @inheritParams member_list
#' @param object (character) The object to add (dataset id, user name, etc.).
#' @param object_type (character) Type of object being added (`"user"`, `"package"`, ...).
#' @param capacity (character) Capacity for the membership.
#' @template args
#' @template key
#' @export
member_create <- function(id, object, object_type, capacity,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  group_id <- resolve_group_or_org_id(id)
  body <- list(
    id = group_id,
    object = resolve_object_identifier(object),
    object_type = object_type,
    capacity = capacity
  )
  membership_request("member_create",
    url = url, key = key, as = as,
    method = "POST", body = body, opts = list(...)
  )
}

#' Remove a membership via member_* endpoints
#'
#' @inheritParams member_create
#' @export
member_delete <- function(id, object, object_type,
  url = get_default_url(), key = get_default_key(), ...) {

  group_id <- resolve_group_or_org_id(id)
  body <- list(
    id = group_id,
    object = resolve_object_identifier(object),
    object_type = object_type
  )
  membership_request("member_delete",
    url = url, key = key,
    method = "POST", body = body, success = TRUE, opts = list(...)
  )
}

#' Report available member roles
#'
#' @param group_type (character) Either `"group"` or `"organization"`.
#' @template args
#' @template key
#' @export
member_roles_list <- function(group_type = "organization",
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  args <- cc(list(group_type = group_type))
  membership_request("member_roles_list",
    url = url, key = key, as = as,
    method = "GET", query = args, opts = list(...)
  )
}

#' Make a user a member of a group
#'
#' @inheritParams member_list
#' @param username (character or `ckan_user`) User to add.
#' @param role (character) Desired role (`"member"`, `"editor"`, `"admin"`).
#' @template args
#' @template key
#' @export
group_member_create <- function(id, username, role,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  group_id <- resolve_group_or_org_id(id)
  body <- list(
    id = group_id,
    username = resolve_username(username),
    role = role
  )
  membership_request("group_member_create",
    url = url, key = key, as = as,
    method = "POST", body = body, opts = list(...)
  )
}

#' Remove a user from a group
#'
#' @inheritParams group_member_create
#' @export
group_member_delete <- function(id, username,
  url = get_default_url(), key = get_default_key(), ...) {

  group_id <- resolve_group_or_org_id(id)
  body <- list(
    id = group_id,
    username = resolve_username(username)
  )
  membership_request("group_member_delete",
    url = url, key = key,
    method = "POST", body = body, success = TRUE, opts = list(...)
  )
}

#' Make a user a member of an organization
#'
#' @inheritParams group_member_create
#' @export
organization_member_create <- function(id, username, role,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  org_id <- resolve_group_or_org_id(id)
  body <- list(
    id = org_id,
    username = resolve_username(username),
    role = role
  )
  membership_request("organization_member_create",
    url = url, key = key,
    as = as, method = "POST", body = body, opts = list(...)
  )
}

#' Remove a user from an organization
#'
#' @inheritParams group_member_delete
#' @export
organization_member_delete <- function(id, username,
  url = get_default_url(), key = get_default_key(), ...) {

  org_id <- resolve_group_or_org_id(id)
  body <- list(
    id = org_id,
    username = resolve_username(username)
  )
  membership_request("organization_member_delete",
    url = url, key = key,
    method = "POST", body = body, success = TRUE, opts = list(...)
  )
}

#' Invite a user to a group
#'
#' @param email (character) Email address for the invitee.
#' @param group_id (character or `ckan_group`) Group identifier.
#' @param role (character) Desired role (`"member"`, `"editor"`, `"admin"`).
#' @template args
#' @template key
#' @export
user_invite <- function(email, group_id, role = "member",
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  grp <- resolve_group_or_org_id(group_id)
  body <- list(email = email, group_id = grp, role = role)
  membership_request("user_invite", url = url, key = key, as = as,
    method = "POST", body = body, opts = list(...))
}

#' List groups the current user can edit
#'
#' @param type (character) Group type, defaults to `"group"`.
#' @param groups (character vector) Optional list of group names to filter.
#' @param all_fields (logical) Return full group dictionaries.
#' @param include_dataset_count,include_extras,include_tags,include_groups,include_users
#'   (logical) Include additional metadata when `all_fields = TRUE`.
#' @param available_only (logical) Remove groups already associated to the context dataset.
#' @param am_member (logical) Only return memberships for the current user.
#' @template paging
#' @template args
#' @template key
#' @export
group_list_authz <- function(type = "group", groups = NULL, all_fields = FALSE,
  include_dataset_count = TRUE, include_extras = FALSE, include_tags = FALSE,
  include_groups = FALSE, include_users = FALSE, available_only = FALSE,
  am_member = FALSE, offset = NULL, limit = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...) {

  bool <- function(x) if (is.null(x)) NULL else as_log(x)
  args <- cc(list(
    type = type,
    groups = groups,
    all_fields = as_log(all_fields),
    include_dataset_count = bool(include_dataset_count),
    include_extras = bool(include_extras),
    include_tags = bool(include_tags),
    include_groups = bool(include_groups),
    include_users = bool(include_users),
    available_only = bool(available_only),
    am_member = bool(am_member),
    offset = offset,
    limit = limit
  ))
  res <- ckan_GET(url, "group_list_authz", query = args, key = key,
    opts = list(...))
  switch(as, json = res, list = lapply(jsl(res), as.ckan_group, url = url),
    table = jsd(res))
}

#' List organizations a user can act on
#'
#' @param id (character or `ckan_user`) Optional user identifier; defaults to the
#'   authenticated user.
#' @param permission (character) Permission to check (defaults to `"manage_group"`).
#' @param include_dataset_count (logical) Include dataset counts in the response.
#' @template args
#' @template key
#' @export
organization_list_for_user <- function(id = NULL, permission = "manage_group",
  include_dataset_count = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  args <- cc(list(
    id = if (is.null(id)) NULL else resolve_user_identifier(id),
    permission = permission,
    include_dataset_count = as_log(include_dataset_count)
  ))
  res <- ckan_GET(url, "organization_list_for_user", query = args,
    key = key, opts = list(...))
  switch(as, json = res, list = lapply(jsl(res), as.ckan_organization, url = url),
    table = jsd(res))
}

membership_request <- function(endpoint, url, key, as = "list",
  method = c("GET", "POST"), query = NULL, body = NULL,
  success = FALSE, list_coercer = NULL, opts = list()) {

  method <- match.arg(method)
  resp <- if (method == "GET") {
    ckan_GET(url, endpoint, query = query, key = key, opts = opts)
  } else {
    ckan_POST(url, endpoint, body = body, key = key, opts = opts)
  }

  if (success) {
    return(jsonlite::fromJSON(resp)$success)
  }

  parse_ckan_response(resp, as, list_coercer)
}
