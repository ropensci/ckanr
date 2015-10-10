#' @title Update a package
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Package identifier
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # First, show a package to see the fields
#' res <- package_show('585d7ea2-ded0-4fed-9b08-61f7e83a3cb2')
#' res
#'
#' ## update just chosen things
#' # Make some changes
#' x <- list(maintainer_email = "heythere2@@things.com")
#'
#' # Then update the packge
#' package_update(x, '585d7ea2-ded0-4fed-9b08-61f7e83a3cb2')
#' }
package_update <- function(x, id, url = get_default_url(), key = get_default_key(),
                           as = 'list', ...) {
  id <- as.ckan_package(id, url = url)
  if (class(x) != "list") {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url, method = 'package_update',
                   body = tojun(x, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"), table = jsd(res))
}
