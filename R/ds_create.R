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
#' # create a package
#' (res <- package_create("foobarrrr", author="Jane Doe"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(package_id = res$id,
#'                        description = "my resource",
#'                        name = "bears",
#'                        upload = file,
#'                        rcurl = "http://google.com"
#' ))
#' ds_create(resource_id = "f4129802-22aa-4437-b9f9-8a8f3b7b2a53",
#'          records = iris, force = TRUE, key = "my-api-key")
#' }

ds_create <- function(resource_id = NULL, resource = NULL, force = FALSE,
  aliases = NULL, fields = NULL, records = NULL, primary_key = NULL,
  indexes = NULL, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  body <- cc(list(resource_id = resource_id, resource = resource, force = force,
                  aliases = aliases, fields = fields, records = records,
                  primary_key = primary_key, indexes = indexes))
  res <- POST(file.path(url, 'api/action/datastore_create'),
              add_headers(Authorization = key),
              body = tojun(body, TRUE),
              encode = "json", ctj(), ...)
  stop_for_status(res)
  res <- content(res, "text", encoding = "UTF-8")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

convert <- function(x){ if (!is.null(x)) { jsonlite::toJSON(x) } else { NULL } }
