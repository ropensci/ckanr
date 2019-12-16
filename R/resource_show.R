#' Show a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @template args
#' @template key 
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/",
#' key = Sys.getenv("CKAN_DEMO_KEY"))
#'
#' # create a package
#' (res <- package_create("yellow7"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(package_id = res$id,
#'                        description = "my resource",
#'                        name = "bears",
#'                        upload = file,
#'                        rcurl = "http://google.com"
#' ))
#'
#' # show the resource
#' resource_show(xx$id)
#'
#'
#' # eg. from the NHM CKAN store
#' resource_show(id = "05ff2255-c38a-40c9-b657-4ccb55ab2feb",
#'               url = "http://data.nhm.ac.uk")
#' }
resource_show <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  id <- as.ckan_resource(id, url = url, key = key)
  res <- ckan_GET(url, 'resource_show', list(id = id$id), key = key,
    opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_resource"),
    table = jsd(res))
}
