#' ckan_file class helpers
#'
#' @export
#' @param x One of character, list, or ckan_file class object
#' @param ... Extra arguments. If `x` is character, the function passes them
#'   on to [file_show()]
#' @examples \dontrun{
#' ckanr_setup(
#'   url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key")
#' )
#'
#' # create item class from only an item ID
#' as.ckan_file("file-id-here")
#'
#' # gives back itself
#' (x <- as.ckan_file(list(id = "file-id-here", name = "file.txt")))
#' as.ckan_file(x)
#' }
as.ckan_file <- function(x, ...) UseMethod("as.ckan_file")

#' @export
as.ckan_file.character <- function(x, ...) get_file(x, ...)

#' @export
as.ckan_file.ckan_file <- function(x, ...) x

#' @export
as.ckan_file.list <- function(x, ...) {
  if (is.null(x$id)) {
    stop("`x` must contain an `id` field", call. = FALSE)
  }
  structure(x, class = "ckan_file")
}

#' @export
#' @rdname as.ckan_file
is.ckan_file <- function(x) inherits(x, "ckan_file")

#' @export
print.ckan_file <- function(x, ...) {
  field <- function(name) {
    val <- x[[name]]
    if (is.null(val)) "-" else as.character(val)[1]
  }
  cat(paste0("<CKAN File> ", field("id")), "\n")
  cat("  Name: ", field("name"), "\n", sep = "")
  cat("  Storage: ", field("storage"), "\n", sep = "")
  cat("  Size: ", field("size"), "\n", sep = "")
  cat("  Owner: ", field("owner_type"), " / ", field("owner_id"), "\n", sep = "")
}

get_file <- function(
  id, url = get_default_url(), key = get_default_key(),
  ...
) {
  ensure_action_available("file_show", url = url, key = key)
  res <- ckan_GET(url, "file_show", list(id = id),
    key = key,
    opts = list(...)
  )
  as_ck(jsl(res), "ckan_file")
}
