#' ckan_related class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_related class object
#' @param ... Further args passed on to \code{\link{related_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (x <- package_create("foobbbbbarrrr") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization"))
#'
#' # create item class from only an item ID
#' as.ckan_related(x$id)
#'
#' # gives back itself
#' (x <- as.ckan_related(x$id))
#' as.ckan_related(x)
#' }
as.ckan_related <- function(x, ...) UseMethod("as.ckan_related")

#' @export
as.ckan_related.character <- function(x, ...) get_related(x, ...)

#' @export
as.ckan_related.ckan_related <- function(x, ...) x

#' @export
as.ckan_related.list <- function(x, ...) structure(x, class = "ckan_related")

#' @export
#' @rdname as.ckan_related
is.ckan_related <- function(x) is(x, "ckan_related")

#' @export
print.ckan_related <- function(x, ...) {
  cat(paste0("<CKAN Related Item> ", x$id), "\n")
  cat("  Title: ", x$title, "\n", sep = "")
  cat("  Description: ", x$description, "\n", sep = "")
  cat("  Type: ", x$type, "\n", sep = "")
  cat("  Views: ", x$view_count, "\n", sep = "")
  cat("  Creator: ", x$created, "\n", sep = "")
}

get_related <- function(id, url = get_default_url(), ...) {
  res <- ckan_POST(url = url, method = 'related_show', key = NULL,
                   body = tojun(list(id = id), TRUE),
                   encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_related")
}
