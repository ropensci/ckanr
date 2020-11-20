#' Update a package
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Package identifier
#' @param http_method (character) which HTTP method (verb) to use; one of 
#' "GET" or "POST". Default: "GET"
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # Create a package
#' (pkg <- package_create("hello-world11", author="Jane Doe"))
#'
#' # Next show the package to see the fields
#' (res <- package_show(pkg$id))
#'
#' ## update just chosen things
#' # Make some changes
#' x <- list(maintainer_email = "heythere2@@things.com")
#'
#' # Then update the packge
#' package_update(x, pkg$id)
#' }
package_update <- function(x, id, http_method = "GET", url = get_default_url(),
                           key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_package(id, url = url, key = key, http_method = http_method)
  if (class(x) != "list") {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url, method = 'package_update',
                   body = tojun(x, TRUE), key = key,
                   encode = "json", headers = ctj(), opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"),
         table = jsd(res))
}
