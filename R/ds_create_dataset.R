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
#' @examples \dontrun{
#' path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' ckanr_setup(url = "http://demo.ckan.org/", key = "my-demo-ckan-org-api-key")
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
ds_create_dataset <- function(package_id, name, path, key = get_default_key(),
                              url = get_default_url(), as = 'list', ...) {
  path <- path.expand(path)
  ext <- strsplit(basename(path), "\\.")[[1]]
  ext <- ext[length(ext)]
  body <- list(package_id = package_id, name = name, format = ext,
               url = 'upload', upload = upload_file(path))
  res <- ckan_POST(url, method = 'resource_create', body = body, key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Add a new table to a datastore
#'
#' BEWARE: This function still doesn't quite work yet.
#'
#' @export
#' @param resource_id (string) Resource id that the data is going to be stored
#'   against.
#' @param force (logical) Set to \code{TRUE} to edit a read-only resource.
#'   Default: FALSE
#' @param resource (dictionary) Resource dictionary that is passed to
#'   resource_create(). Use instead of \code{resource_id} (optional)
#' @param aliases (character) Names for read only aliases of the resource.
#'   (optional)
#' @param fields (list) Fields/columns and their extra metadata. (optional)
#' @param records (list) The data, eg: \code{[{"dob": "2005", "some_stuff":
#'   ["a", "b"]}]} (optional)
#' @param primary_key (character) Fields that represent a unique key (optional)
#' @param indexes (character) Indexes on table (optional)
#' @template key
#' @template args
#' @references \url{http://bit.ly/1G9cnBl}
#' @examples \dontrun{
#' ds_create(resource_id = "f4129802-22aa-4437-b9f9-8a8f3b7b2a53",
#'          records = iris, force = TRUE, key = "my-api-key")
#' }

ds_create <- function(resource_id = NULL, resource = NULL, force = FALSE,
                      aliases = NULL, fields = NULL, records = NULL,
                      primary_key = NULL, indexes = NULL,
                      key = get_default_key(),
                      url = get_default_url(), as = 'list', ...) {

  body <- cc(list(resource_id = resource_id, resource = resource, force = force,
                  aliases = aliases, fields = fields, records = convert(records),
                  primary_key = primary_key, indexes = indexes))
  res <- POST(file.path(url, 'api/action/datastore_create'),
              add_headers(Authorization = key),
              body = body, ...)
  stop_for_status(res)
  res <- content(res, "text")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

convert <- function(x){ if (!is.null(x)) { jsonlite::toJSON(x) } else { NULL } }
