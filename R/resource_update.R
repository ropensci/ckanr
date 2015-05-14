#' Update a resource's file attachment
#'
#'
#' This function will only update a resource's file attachment and the metadata
#' key "last_updated". Other metadata, such as name or description, are not
#' updated.
#'
#' The new file must exist on a local path. R objects have to be written to a
#' file, e.g. using \code{tempfile()} - see example.
#'
#' For convenience, CKAN base url and API key default to the global options,
#' which are set by \code{set_ckanr_url("http://my-ckan.org/")} and
#' \code{set_api_key("my-ckan-api-key")}, respectively.
#'
#' @export
#' @importFrom httr upload_file add_headers POST
#'
#' @param id (character) Resource ID to update (required)
#' @param path (character) Local path of the file to upload (required)
#' @param key A CKAN API key with write permissions to the resource's dataset
#'    (default: \code{api_key()})
#' @template args
#' @return The HTTP response from CKAN, formatted as list (default), table, or JSON.
#' @references
#' \url{http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.create.resource_create}
#' @examples \dontrun{
#' # Using an existing file and explicit CKAN URL and API key
#' # Note: enter valid values for id, url, and key
#' resource_update(id="an-existing-resource-id",
#'                 path=system.file("examples", "actinidiaceae.csv", package = "ckanr"),
#'                 url="http://my-ckan-instance.org/", key="my-ckan-api-key")
#'
#' # Using an R object written to a tempfile, and implicit CKAN URL and API key
#' data <- installed.packages()
#' path <- tempfile(fileext=".csv")
#' write.csv(data, path)
#' set_ckanr_url("http://demo.ckan.org/")
#' set_api_key("my-demo-ckan-org-api-key")
#' resource_update(id="an-existing-resource-id", path=path)
#' }
resource_update <- function(id, path,
                            url=get_ckanr_url(),
                            key=getOption("X-CKAN-API-Key"),
                            as = 'list', ...) {
  path <- path.expand(path)
  body <- list(id = id,
               url = 'upload',
               upload = upload_file(path),
               last_modified=Sys.time())
  res <- POST(file.path(url, ck(), 'resource_update'),
              add_headers(Authorization = key),
              body = body, ...)
  stop_for_status(res)
  res <- content(res, "text")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
