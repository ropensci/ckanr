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
#' which are set by \code{ckanr_setup}.
#'
#' @export
#' @importFrom httr upload_file
#'
#' @param id (character) Resource ID to update (required)
#' @param path (character) Local path of the file to upload (required)
#' @template key
#' @template args
#' @return The HTTP response from CKAN, formatted as list (default), table, or JSON.
#' @references
#' \url{http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.create.resource_create}
#' @examples \dontrun{
#' # Using an existing file and explicit CKAN URL and API key
#' path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' # Note: enter valid values for id, url, and key
#' resource_update(id = "an-existing-resource-id",
#'                 path = path,
#'                 key = "my-ckan-api-key",
#'                 url = "http://my-ckan.org/")
#'
#' # Using default settings
#' ckanr_setup(url = "http://demo.ckan.org/", key = "my-demo-ckan-org-api-key")
#' path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' resource_update(id="an-existing-resource-id", path = path)
#'
#' # Using an R object written to a tempfile, and implicit CKAN URL and API key
#' write.csv(data <- installed.packages(), path <- tempfile(fileext = ".csv"))
#' ckanr_setup(url = "http://demo.ckan.org/", key = "my-demo-ckan-org-api-key")
#' resource_update(id="an-existing-resource-id", path = path)
#'
#' # Testing: see ?ckanr_setup to set default test CKAN url, key, package id
#' ckanr_setup(test_url = "http://my-ckan.org/",
#'             test_key = "my-ckan-api-key",
#'             test_did = "an-existing-package-id",
#'             test_rid = "an-existing-resource-id")
#' resource_update(id = get_test_rid(),
#'                 path = system.file("examples",
#'                                    "actinidiaceae.csv",
#'                                    package = "ckanr"),
#'                 key = get_test_key(),
#'                 url = get_test_url())
#' }
resource_update <- function(id, path, key = get_default_key(),
                            url = get_default_url(), as = 'list', ...) {
  path <- path.expand(path)
  body <- list(id = id, url = 'upload', upload = upload_file(path),
               last_modified = Sys.time())
  res <- ckan_POST(url, method = 'resource_update', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
