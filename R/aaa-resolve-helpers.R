# Internal identifier resolution helpers shared across multiple modules.

resolve_group_or_org_id <- function(x) {
  if (is.ckan_group(x) || is.ckan_organization(x)) {
    return(x$id)
  }
  if (is.list(x) && !is.null(x$id)) {
    return(x$id)
  }
  x
}

resolve_object_identifier <- function(x) {
  if (is.ckan_package(x) || is.ckan_group(x) || is.ckan_organization(x) ||
    is.ckan_user(x)) {
    return(if (!is.null(x$id)) x$id else x$name)
  }
  if (is.list(x)) {
    if (!is.null(x$id)) {
      return(x$id)
    }
    if (!is.null(x$name)) {
      return(x$name)
    }
  }
  x
}

resolve_username <- function(x) {
  if (is.ckan_user(x)) {
    return(if (!is.null(x$name)) x$name else x$id)
  }
  if (is.list(x)) {
    if (!is.null(x$name)) {
      return(x$name)
    }
    if (!is.null(x$id)) {
      return(x$id)
    }
  }
  x
}

resolve_user_identifier <- function(x) {
  if (is.ckan_user(x)) {
    return(if (!is.null(x$id)) x$id else x$name)
  }
  if (is.list(x)) {
    if (!is.null(x$id)) {
      return(x$id)
    }
    if (!is.null(x$name)) {
      return(x$name)
    }
  }
  x
}
