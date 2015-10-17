#' Update a resource's metadata
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
#' # Get a resource
#' res <- resource_show("b85948b6-f9ea-4392-805e-00511d6cf6c6")
#' res$description
#'
#' # Make some changes
#' x <- list(description = "My newer description")
#' resource_patch(x, id = res)
#' # or pass id in directly
#' # resource_patch(x, id = res$id)
#' }
resource_patch <- function(x, id, key = get_default_key(),
                           url = get_default_url(), as = 'list', ...) {
  id <- as.ckan_resource(id, url = url)
  if (!is(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url, method = 'resource_patch', body = x, key = key,
                   encode = "json", content_type_json(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_resource"), table = jsd(res))
}
