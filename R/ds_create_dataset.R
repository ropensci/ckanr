#' Datastore - create a new resource on an existing dataset
#'
#' @export
#'
#' @param package_id (character) Existing package ID (required)
#' @param name (character) Name of the new resource (required)
#' @param path (character) Path of the file to add (required)
#' @template key
#' @template args
#' @references
#' \url{http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.create.resource_create}
#' @details This function is deprecated - will be defunct in the next version
#' of this package
#' @examples \dontrun{
#' path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-demo-ckan-org-api-key")
#' ds_create_dataset(package_id='testingagain', name="mydata", path = path)
#'
#' # Testing: see ?ckanr_setup to set test settings
#' ckanr_setup(test_url = "http://my-ckan.org/",
#'             test_key = "my-ckan-api-key",
#'             test_did="an-existing-package-id",
#'             test_rid="an-existing-resource-id")
#' ds_create_dataset(package_id=get_test_pid(), name="mydata",
#'                   path=system.file("examples",
#'                                    "actinidiaceae.csv",
#'                                    package = "ckanr"),
#'                   key = get_test_key(),
#'                   url = get_test_url())
#' }
ds_create_dataset <- function(package_id, name, path, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  .Deprecated("resource_create", "ckanr", msg = "deprecated, see ?resource_create")

  path <- path.expand(path)
  ext <- strsplit(basename(path), "\\.")[[1]]
  ext <- ext[length(ext)]
  body <- list(package_id = package_id, name = name, format = ext,
               url = 'upload', upload = upload_file(path))
  res <- ckan_POST(url, method = 'resource_create', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
