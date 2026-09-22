#' Autocomplete dataset names.
#'
#' Return a list of datasets (packages) with names or titles that contain
#' a query string. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.package_autocomplete>
#' for the official API contract.
#'
#' @export
#' @template autocomplete
#' @param limit (numeric) The maximum number of datasets to return.
#' Default: 10 (optional)
#' @template args
#' @template key
#' @return A list of dataset dictionaries. Each dictionary has at least
#' the keys `name` and `title`. With `as = "table"`, a data.frame; with
#' `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.package_autocomplete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' package_autocomplete(q = "spending")
#' package_autocomplete(q = "spending", limit = 5, as = "table")
#' }
package_autocomplete <- function(
  q, limit = 10, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(q = q, limit = limit))
  res <- ckan_GET(url, "package_autocomplete", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Autocomplete resource formats.
#'
#' Return a list of resource formats whose names contain a query string. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.format_autocomplete>
#' for the official API contract.
#'
#' @export
#' @template autocomplete
#' @param limit (numeric) The maximum number of resource formats to return.
#' Default: 5 (optional)
#' @template args
#' @template key
#' @return A character vector of matching format names. With `as = "table"`,
#' a data.frame; with `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.format_autocomplete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' format_autocomplete(q = "csv")
#' }
format_autocomplete <- function(
  q, limit = 5, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(q = q, limit = limit))
  res <- ckan_GET(url, "format_autocomplete", args, key = key, opts = list(...))
  values <- unlist(jsl(res), use.names = FALSE)
  switch(as,
    json = res,
    list = values,
    table = data.frame(name = values, stringsAsFactors = FALSE)
  )
}

#' Autocomplete user names.
#'
#' Return a list of user names that contain a query string. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.user_autocomplete>
#' for the official API contract.
#'
#' @export
#' @template autocomplete
#' @param limit (numeric) The maximum number of user names to return.
#' Default: 20 (optional)
#' @template args
#' @template key
#' @return A list of user dictionaries, each with the keys `name`,
#' `fullname`, and `id`. With `as = "table"`, a data.frame; with
#' `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.user_autocomplete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' user_autocomplete(q = "admin")
#' }
user_autocomplete <- function(
  q, limit = 20, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(q = q, limit = limit))
  res <- ckan_GET(url, "user_autocomplete", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Autocomplete group names.
#'
#' Return a list of group names that contain a query string. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.group_autocomplete>
#' for the official API contract.
#'
#' @export
#' @template autocomplete
#' @param limit (numeric) The maximum number of groups to return.
#' Default: 20 (optional)
#' @template args
#' @template key
#' @return A list of group dictionaries, each with the keys `name`,
#' `title`, and `id`. With `as = "table"`, a data.frame; with
#' `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.group_autocomplete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' group_autocomplete(q = "data")
#' }
group_autocomplete <- function(
  q, limit = 20, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(q = q, limit = limit))
  res <- ckan_GET(url, "group_autocomplete", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' Autocomplete organization names.
#'
#' Return a list of organization names that contain a query string. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.organization_autocomplete>
#' for the official API contract.
#'
#' @export
#' @template autocomplete
#' @param limit (numeric) The maximum number of organizations to return.
#' Default: 20 (optional)
#' @template args
#' @template key
#' @return A list of organization dictionaries, each with the keys `name`,
#' `title`, and `id`. With `as = "table"`, a data.frame; with
#' `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.organization_autocomplete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' organization_autocomplete(q = "data")
#' }
organization_autocomplete <- function(
  q, limit = 20, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(q = q, limit = limit))
  res <- ckan_GET(url, "organization_autocomplete", args,
    key = key, opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}
