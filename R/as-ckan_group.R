#' ckan_group class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_group class object
#' @param ... Further args passed on to \code{\link{group_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (grps <- group_list())
#' grps[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_group(grps[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_group(grps[[3]]$id))
#' as.ckan_group(x)
#' }
as.ckan_group <- function(x, ...) UseMethod("as.ckan_group")

#' @export
as.ckan_group.character <- function(x, ...) get_group(x, ...)

#' @export
as.ckan_group.ckan_group <- function(x, ...) x

#' @export
as.ckan_group.list <- function(x, ...) structure(x, class = "ckan_group")

#' @export
#' @rdname as.ckan_group
is.ckan_group <- function(x) is(x, "ckan_group")

#' @export
print.ckan_group <- function(x, ...) {
  cat(paste0("<CKAN Group> ", x$id), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  cat("  Display Name: ", x$display_name, "\n", sep = "")
  cat("  No. users: ", length(x$users), "\n", sep = "")
  cat("  No. packages: ", x$package_count, "\n", sep = "")
  cat("  No. followers: ", x$num_followers, "\n", sep = "")
  cat("  Created: ", x$created, "\n", sep = "")
}

get_group <- function(id, url = get_default_url(), ...) {
  res <- ckan_POST(url = url, method = 'group_show', key = NULL,
                   body = tojun(list(id = id), TRUE),
                   encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_group")
}
