#' Update a package's metadata
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Resource ID to update (required)
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # Create a package
#' (res <- package_create("hello-world4", author="Jane Doe"))
#'
#' # Get a resource
#' res <- package_show(res$id)
#' res$title
#' res$author_email
#'
#' # Make some changes
#' x <- list(title = "!hello world!", maintainer_email = "hello@@world.com")
#' package_patch(x, id = res$id)
#' }
package_patch <- function(x, id, key = get_default_key(),
                           url = get_default_url(), as = 'list', ...) {
  if (!is(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id
  res <- ckan_POST(url, method = 'package_patch', body = x, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
