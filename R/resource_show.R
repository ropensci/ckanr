#' Show a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @template args
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
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
resource_show <- function(id, url = get_default_url(), as = 'list', ...) {
  id <- as.ckan_resource(id, url = url)
  res <- ckan_POST(url, 'resource_show', body = list(id = id$id), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_resource"), table = jsd(res))
}
