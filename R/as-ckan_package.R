#' ckan_package class helpers
#'
#' @export
#' @param x Variety of things, character, list, or ckan_package class object
#' @param ... Further args passed on to [package_show()] if
#' character given. In particular, if GET is not supported you can 
#' try the `http_method` parameter to set a different HTTP verb
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key"))
#'
#' (pkgs <- package_search())
#' pkgs$results
#' pkgs$results[[3]]
#'
#' # create item class from only an item ID
#' as.ckan_package(pkgs$results[[3]]$id)
#'
#' # gives back itself
#' (x <- as.ckan_package(pkgs$results[[3]]$id))
#' as.ckan_package(x)
#' }
as.ckan_package <- function(x, ...) {
  UseMethod("as.ckan_package")
}

#' @export
as.ckan_package.character <- function(x, ...) {
  get_package(x, ...)
}

#' @export
as.ckan_package.ckan_package <- function(x, ...) x

#' @export
as.ckan_package.list <- function(x, ...) {
  structure(x, class = "ckan_package")
}

#' @export
#' @rdname as.ckan_package
is.ckan_package <- function(x) inherits(x, "ckan_package")

#' @export
print.ckan_package <- function(x, ...) {
  cat(paste0("<CKAN Package> ", x$id), "\n")
  cat("  Title: ", title_x(x$title), "\n", sep = "")
  cat("  Creator/Modified: ", x$metadata_created, " / ",
    x$metadata_modified, "\n", sep = "")
  cat("  Resources (up to 5): ", sift_res(x$resources), "\n", sep = "")
  cat("  Tags (up to 5): ", sift_res(x$tags), "\n", sep = "")
  cat("  Groups (up to 5): ", sift_res(x$groups), "\n", sep = "")
}

title_x <- function(w) {
  if (is.list(w)) {
    w <- paste(names(w), unlist(unname(w)), sep = ": ")
    return(paste0("\n   ", paste0(w, collapse = "\n   ")))
  }
  return(w)
}

sift_res <- function(z) {
  if (!is.null(z) && length(z) > 0) {
    tmp <- pluck(z, "name")
    if (is.list(tmp)) {
      tmp <- unlist(lapply(tmp, function(b) {
        if (!is.list(b)) return(b)
        if (!haz_names(b)) return(b)
        b <- unlist(b)
        b <- b[nchar(b) > 0]
        if (length(b) > 1) b <- b[1]
        paste(names(b), unlist(unname(b)), sep = ": ")
      }))
    }
    paste0(cc(na.omit(tmp[1:5])), collapse = ", ")
  } else {
    NULL
  }
}

get_package <- function(id, url = get_default_url(), key = get_default_key(),
  http_method = "GET", ...) {

  res <- package_show(id, http_method = http_method, url = url, key = key,
    as = "json", ...)
  as_ck(jsl(res), "ckan_package")
}
