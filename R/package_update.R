#' @title Update a package
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Package identifier
#' @template args
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
#' x <- list(maintainer_email = "stuff@@things.com")
#'
#' # Then update the packge
#' package_update(x, '585d7ea2-ded0-4fed-9b08-61f7e83a3cb2')
#' }
package_update <- function(x, id, url = get_default_url(),
                           as = 'list', ...) {
  if (class(x) != "list") {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id
  res <- ckan_POST(url, method = 'package_update', body = x, key = getOption("ckan_demo_key"), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
