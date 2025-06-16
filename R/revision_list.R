#' Return a list of the IDs of the site's revisions.
#'
#' @export
#' @template args
#' @template key
#' @examples \dontrun{
#' revision_list()
#' revision_list(as = "table")
#' revision_list(as = "json")
#' }
revision_list <- function(url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  ver <- try(ckan_version(url)$version_num, silent = TRUE)
  if (inherits(ver, "try-error")) {
    ver <- NA
  }

  if (ver >= 29.0) {
    warning('The ckan.logic.action.get.revision_list endpoint was removed in CKAN 2.9. Returning NULL.')
    result <- NULL
  } else {
    res <- ckan_GET(url, 'revision_list', key = key, opts = list(...))
    result <- switch(as, json = res, list = jsl(res), table = jsd(res))
  }
  result
}
