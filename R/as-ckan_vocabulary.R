#' ckan_vocabulary class helpers
#'
#' @export
#' @param x Variety of inputs: character, list, or ckan_vocabulary object
#' @param ... Additional arguments passed to `vocabulary_show()` when
#'   retrieving by identifier.
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' vocab <- vocabulary_create(name = sprintf("demo_vocab_%s", sample.int(1e4, 1)))
#'
#' # create class from an id
#' as.ckan_vocabulary(vocab$id)
#'
#' # passing through existing objects is a no-op
#' as.ckan_vocabulary(vocab)
#' }
as.ckan_vocabulary <- function(x, ...) UseMethod("as.ckan_vocabulary")

#' @export
as.ckan_vocabulary.character <- function(x, ...) get_vocabulary(x, ...)

#' @export
as.ckan_vocabulary.ckan_vocabulary <- function(x, ...) x

#' @export
as.ckan_vocabulary.list <- function(x, ...) structure(x, class = "ckan_vocabulary")

#' @export
#' @rdname as.ckan_vocabulary
is.ckan_vocabulary <- function(x) inherits(x, "ckan_vocabulary")

#' @export
print.ckan_vocabulary <- function(x, ...) {
  label <- if (!is.null(x$id)) x$id else x$name
  cat(paste0("<CKAN Vocabulary> ", label), "\n")
  cat("  Name: ", x$name, "\n", sep = "")
  tag_count <- if (!is.null(x$tags)) length(x$tags) else 0L
  cat("  Tags: ", tag_count, "\n", sep = "")
}

get_vocabulary <- function(id, url = get_default_url(), key = get_default_key(),
  ...) {

  res <- ckan_GET(url, 'vocabulary_show', list(id = id), key = key,
    opts = list(...))
  as_ck(jsl(res), "ckan_vocabulary")
}
