#' ckanr S3 classes
#'
#' @export
#' @name ckan_classes
#' @param x Variety of things, character, list, or ckan_package class object
#' @param ... Further args passed on to \code{\link{package_show}} if character given
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' (pkgs <- package_search())
#' pkgs$results
#' pkgs$results[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_package("0699f475-6978-473a-8448-42585074b6f1")
#'
#' # gives back itself
#' (x <- as.ckan_package("0699f475-6978-473a-8448-42585074b6f1"))
#' as.ckan_package(x)
#' }

#' @export
#' @rdname ckan_classes
as.ckan_package <- function(x, ...) UseMethod("as.ckan_package")

#' @export
as.ckan_package.character <- function(x, ...) get_package(x, ...)

#' @export
as.ckan_package.ckan_package <- function(x, ...) x

#' @export
as.ckan_package.list <- function(x, ...) structure(x, class = "ckan_package")

#' @export
#' @rdname ckan_classes
is.ckan_package <- function(x) is(x, "ckan_package")

#' @export
print.ckan_package <- function(x, ...) {
  cat("<CKAN Package>", "\n")
  cat("  Title: ", x$title, "\n", sep = "")
  cat("  ID: ", x$id, "\n", sep = "")
  cat("  Creator/Modified: ", x$metadata_created, " / ", x$metadata_modified, "\n", sep = "")
  cat("  Resources (up to 5): ", sift_res(x$resources), "\n", sep = "")
  cat("  Tags (up to 5): ", sift_res(x$tags), "\n", sep = "")
  cat("  Groups (up to 5): ", sift_res(x$groups), "\n", sep = "")
}

sift_res <- function(z) {
  if (!is.null(z) && length(z) > 0) {
    tmp <- pluck(z, "name")
    paste0(cc(na.omit(tmp[1:5])), collapse = ", ")
  } else {
    NULL
  }
}

get_package <- function(id, url = get_default_url(), ...) {
  # body <- cc(list(id = id, use_default_schema = use_default_schema))
  # res <- ckan_POST(url, 'package_show', body = body, ...)
  # args <- cc(list(id = id, use_default_schema = use_default_schema))
  # res <- ckan_GET(url, 'package_show', query = args, ...)
  res <- ckan_POST(url = url, method = 'package_show', key = NULL,
                   body = tojun(list(id = id), TRUE), encode = "json", ctj(), ...)
  as_ck(jsl(res), "ckan_package")
}
