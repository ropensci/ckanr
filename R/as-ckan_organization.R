#' ckan_organization class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_organization class object
#' @param ... Further args passed on to \code{\link{organization_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (orgs <- organization_list())
#' orgs[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_organization(orgs[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_organization(orgs[[3]]$id))
#' as.ckan_organization(x)
#' }
as.ckan_organization <- function(x, ...) UseMethod("as.ckan_organization")

#' @export
as.ckan_organization.character <- function(x, ...) get_organization(x, ...)

#' @export
as.ckan_organization.ckan_organization <- function(x, ...) x

#' @export
as.ckan_organization.list <- function(x, ...) structure(x, class = "ckan_organization")

#' @export
#' @rdname as.ckan_organization
is.ckan_organization <- function(x) is(x, "ckan_organization")

#' @export
print.ckan_organization <- function(x, ...) {
  cat(paste0("<CKAN Organization> ", x$id), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  cat("  Display name: ", x$display_name, "\n", sep = "")
  cat("  No. Packages: ", x$package_count, "\n", sep = "")
  cat("  No. Users: ", length(x$users), "\n", sep = "")
}

get_organization <- function(id, url = get_default_url(), ...) {
  res <- ckan_POST(url = url, method = 'organization_show', key = NULL,
                   body = tojun(list(id = id), TRUE),
                   encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_organization")
}
