#' Return a dataset (package's) revisions as a list of dictionaries.
#'
#' @export
#' @param id (character) Package identifier.
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("dolphins"))
#'
#' # list package revisions
#' package_revision_list(res$id)
#'
#' # Make change to the package
#' x <- list(title = "dolphins and things")
#' package_patch(x, id = res$id)
#'
#' # list package revisions
#' package_revision_list(res$id)
#'
#' # Output different formats
#' package_revision_list(res$id, as = "table")
#' package_revision_list(res$id, as = "json")
#' }
package_revision_list <- function(id, url = get_default_url(),
  key = get_default_key(), as = "list", ...) {

  ver <- try(ckan_version(url)$version_num, silent = TRUE)
  if (inherits(ver, "try-error")) {
    ver <- NA
  }

  if (ver >= 29.0) {
    warning('The ckan.logic.action.get.package_revision_list endpoint was removed in CKAN 2.9. Returning NULL.')
    result <- NULL
  } else {
    res <- ckan_GET(url, 'package_revision_list', list(id = id),
    key = key, opts = list(...))
    result <- switch(as, json = res, list = jsl(res), table = jsd(res))
  }
  
  result
}
