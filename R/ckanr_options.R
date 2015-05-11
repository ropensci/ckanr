#' Get ckanr options
#'
#' @export
#' @return Prints your base url, and API key (if used)
#' @seealso \code{\link{set_ckanr_url}}, \code{\link{get_ckanr_url}},
#' \code{\link{set_api_key}}
#' @family ckanr options
#' @examples
#' ckanr_options()
ckanr_options <- function() {
  ops <- list(url = getOption("ckanr.default.url", NULL),
              key = getOption("X-CKAN-API-Key", NULL)
  )
  structure(ops, class = "ckanr_options")
}

#' @export
print.ckanr_options <- function(x) {
  cat(paste0("Base URL: ", x$url), sep = "\n")
  cat("API key: ", x$key)
}
