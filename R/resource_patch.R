#' Update a resource's metadata
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Resource ID to update (required)
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("twist", author="Alexandria"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(package_id = res$id, description = "my resource"))
#'
#' # Get a resource
#' res <- resource_show(xx$id)
#' res$description
#'
#' # Make some changes
#' x <- list(description = "My newer description")
#' z <- resource_patch(x, id = res)
#' z$description
#'
#' # Add an extra key:value pair
#' extra <- list("extra_key" = "my special value")
#' zz <- resource_patch(extra, id = res)
#' zz$extra_key
#' }
resource_patch <- function(x, id, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_resource(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url, method = 'resource_patch', body = x, key = key,
    encode = "json", headers = ctj(), opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_resource"),
    table = jsd(res))
}
