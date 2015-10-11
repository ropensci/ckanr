#' Delete a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("yellow9"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(res,
#'                        description = "my resource",
#'                        name = "bears",
#'                        upload = file,
#'                        rcurl = "http://google.com"
#' ))
#'
#' # delete the resource
#' resource_delete(xx)
#' }
resource_delete <- function(id, key = get_default_key(), url = get_default_url(), ...) {
  id <- as.ckan_resource(id, url = url)
  tmp <- ckan_POST(url, 'resource_delete', body = list(id = id$id), key = key, ...)
  jsonlite::fromJSON(tmp)$success
}
