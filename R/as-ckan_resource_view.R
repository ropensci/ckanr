#' ckan_resource_view class helpers
#'
#' @export
#' @param x Variety of things: character, list, or `ckan_resource_view` object
#' @param ... Further arguments passed to [ckanr::resource_view_show()] when `x` is an
#'   identifier.
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/",
#'   key = Sys.getenv("CKAN_DEMO_KEY"))
#'
#' res <- package_show("sample-dataset")
#' views <- resource_view_list(res$resources[[1]]$id)
#'
#' # Coerce from ID
#' as.ckan_resource_view(views[[1]]$id)
#'
#' # Pass through existing objects
#' as.ckan_resource_view(views[[1]])
#' }
as.ckan_resource_view <- function(x, ...) UseMethod("as.ckan_resource_view")

#' @export
as.ckan_resource_view.character <- function(x, ...) get_resource_view(x, ...)

#' @export
as.ckan_resource_view.ckan_resource_view <- function(x, ...) x

#' @export
as.ckan_resource_view.list <- function(x, ...) structure(x, class = "ckan_resource_view")

#' @export
#' @rdname as.ckan_resource_view
is.ckan_resource_view <- function(x) inherits(x, "ckan_resource_view")

#' @export
print.ckan_resource_view <- function(x, ...) {
  cat(paste0("<CKAN Resource View> ", x$id), "\n")
  cat("  Title: ", x$title, "\n", sep = "")
  cat("  Type: ", x$view_type, "\n", sep = "")
  cat("  Resource: ", x$resource_id, "\n", sep = "")
}

get_resource_view <- function(id, url = get_default_url(), key = get_default_key(),
    ...) {
  res <- ckan_GET(url, 'resource_view_show', list(id = id), key = key,
    opts = list(...))
  as_ck(jsl(res), "ckan_resource_view")
}
