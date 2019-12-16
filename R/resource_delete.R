#' Delete a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @param url Base url to use. Default: http://data.techno-science.ca
#' See also [ckanr_setup()] and [get_default_url()].
#' @param ... Curl args passed on to [crul::verb-POST] (optional)
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = Sys.getenv("CKAN_DEMO_KEY"))
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
resource_delete <- function(id, url = get_default_url(),
  key = get_default_key(), ...) {
  
  id <- as.ckan_resource(id, url = url)
  tmp <- ckan_POST(url, 'resource_delete', body = list(id = id$id), key = key,
    opts = list(...))
  jsonlite::fromJSON(tmp)$success
}
