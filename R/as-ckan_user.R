#' ckan_user class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_user class object
#' @param ... Further args passed on to [user_show()] if character given
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key"))
#'
#' (usrs <- user_list())
#' usrs[1:3]
#' usrs[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_user(usrs[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_user(usrs[[3]]$id))
#' as.ckan_user(x)
#' }
as.ckan_user <- function(x, ...) UseMethod("as.ckan_user")

#' @export
as.ckan_user.character <- function(x, ...) get_user(x, ...)

#' @export
as.ckan_user.ckan_user <- function(x, ...) x

#' @export
as.ckan_user.list <- function(x, ...) structure(x, class = "ckan_user")

#' @export
#' @rdname as.ckan_user
is.ckan_user <- function(x) inherits(x, "ckan_user")

#' @export
print.ckan_user <- function(x, ...) {
  cat(paste0("<CKAN User> ", x$id), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  cat("  Display Name: ", x$display_name, "\n", sep = "")
  cat("  Full Name: ", x$fullname, "\n", sep = "")
  cat("  No. Packages: ", x$number_created_packages, "\n", sep = "")
  cat("  No. Edits: ", x$number_of_edits, "\n", sep = "")
  cat("  Created: ", x$created, "\n", sep = "")
}

get_user <- function(id, url = get_default_url(), key = get_default_key(),
    ...) {
  res <- ckan_GET(url, 'user_show', list(id = id), key = key, opts = list(...))
  as_ck(jsl(res), "ckan_user")
}
