#' ckan_tag class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_tag class object
#' @param ... Further args passed on to \code{\link{tag_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (tags <- tag_search(query = 'ta'))
#' tags[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_tag(tags[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_tag(tags[[3]]$id))
#' as.ckan_tag(x)
#' }
as.ckan_tag <- function(x, ...) UseMethod("as.ckan_tag")

#' @export
as.ckan_tag.character <- function(x, ...) get_tag(x, ...)

#' @export
as.ckan_tag.ckan_tag <- function(x, ...) x

#' @export
as.ckan_tag.list <- function(x, ...) structure(x, class = "ckan_tag")

#' @export
#' @rdname as.ckan_tag
is.ckan_tag <- function(x) is(x, "ckan_tag")

#' @export
print.ckan_tag <- function(x, ...) {
  cat(paste0("<CKAN Tag> ", x$id), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  cat("  Display name: ", x$display_name, "\n", sep = "")
  cat("  Vocabulary id: ", x$vocabulary_id, "\n", sep = "")
  cat("  No. Packages: ", length(x$packages), "\n", sep = "")
  cat("  Packages (up to 5): ", sift_res(x$packages), "\n", sep = "")
}

get_tag <- function(id, url = get_default_url(), ...) {
  res <- ckan_POST(url = url, method = 'tag_show', key = NULL,
                   body = tojun(list(id = id), TRUE),
                   encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_tag")
}
