#' Update a package's metadata
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Resource ID to update (optional, required if 
#' x does not have an "id" field)
#' @param extras (character vector) - the dataset's extras
#' (optional), extras are arbitrary (key: value) metadata items that can be
#' added to datasets, each extra dictionary should have keys 'key' (a string),
#' 'value' (a string)
#' @param http_method (character) which HTTP method (verb) to use; one of 
#' "GET" or "POST". Default: "GET"
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # Create a package
#' (res <- package_create("hello-world13", author="Jane Doe"))
#'
#' # Get a resource
#' res <- package_show(res$id)
#' res$title
#'
#' # patch
#' package_patch(res, extras = list(list(key = "foo", value = "bar")))
#' unclass(package_show(res))
#' }
package_patch <- function(x, id = NULL, extras = NULL, http_method = "GET", 
  key = get_default_key(),url = get_default_url(), as = 'list', ...) {

  x <- as.ckan_package(x, url = url, key = key, http_method = http_method)
  x <- unclass(x)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  if (!"id" %in% names(x)) {
    if (is.null(id))
      stop("`id` field not found in `x`; provide a value to `id` param",
        call. = FALSE)
    x$id <- id$id
  }
  if (!is.null(extras)) x$extras <- extras
  res <- ckan_POST(url, method = 'package_patch', body = x, key = key,
    encode = "json", opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"),
         table = jsd(res))
}
