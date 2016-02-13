#' ckan_resource class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_package class object
#' @param ... Further args passed on to \code{\link{resource_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (resrcs <- resource_search(q = 'name:data'))
#' resrcs$results
#' resrcs$results[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_resource(resrcs$results[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_resource(resrcs$results[[3]]$id))
#' as.ckan_resource(x)
#' }
as.ckan_resource <- function(x, ...) UseMethod("as.ckan_resource")

#' @export
as.ckan_resource.character <- function(x, ...) get_resource(x, ...)

#' @export
as.ckan_resource.ckan_resource <- function(x, ...) x

#' @export
as.ckan_resource.list <- function(x, ...) structure(x, class = "ckan_resource")

#' @export
#' @rdname as.ckan_resource
is.ckan_resource <- function(x) is(x, "ckan_resource")

#' @export
print.ckan_resource <- function(x, ...) {
  cat(paste0("<CKAN Resource> ", x$id), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  cat("  Description: ", x$description, "\n", sep = "")
  cat("  Creator/Modified: ", x$created, " / ", x$last_modified, "\n", sep = "")
  cat("  Size: ", x$size, "\n", sep = "")
  cat("  Format: ", x$format, "\n", sep = "")
}

get_resource <- function(id, url = get_default_url(), ...) {
  res <- ckan_POST(url = url, method = 'resource_show', key = NULL,
                   body = tojun(list(id = id), TRUE),
                   encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_resource")
}
