#' Add a new table to a datastore
#'
#' BEWARE: This function still doesn't quite work yet.
#'
#' @export
#' @param resource_id (string) Resource id that the data is going to be stored
#' against.
#' @param force (logical) Set to `TRUE` to edit a read-only resource.
#' Default: `FALSE`
#' @param resource (dictionary) Resource dictionary that is passed to
#' [resource_create()]. Use instead of `resource_id` (optional)
#' @param aliases (character) Names for read only aliases of the resource.
#' (optional)
#' @param fields (list) Fields/columns and their extra metadata. (optional)
#' @param records (list) The data, eg: `[{"dob": "2005", "some_stuff":
#' ["a", "b"]}]` (optional)
#' @param primary_key (character) Fields that represent a unique key (optional)
#' @param indexes (character) Indexes on table (optional)
#' @template key
#' @template args
#' @references http://bit.ly/ds_create
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key"))
#' 
#' # create a package
#' (res <- package_create("foobarrrrr", author="Jane Doe"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(package_id = res$id,
#'                        description = "my resource",
#'                        name = "bears",
#'                        upload = file,
#'                        rcurl = "http://google.com"
#' ))
#' ds_create(resource_id = xx$id, records = iris, force = TRUE)
#' resource_show(xx$id)
#' }

ds_create <- function(resource_id = NULL, resource = NULL, force = FALSE,
  aliases = NULL, fields = NULL, records = NULL, primary_key = NULL,
  indexes = NULL, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  body <- cc(list(resource_id = resource_id, resource = resource, force = force,
                  aliases = aliases, fields = fields, records = records,
                  primary_key = primary_key, indexes = indexes))
  con <- crul::HttpClient$new(file.path(url, 'api/action/datastore_create'),
    headers = c(list(Authorization = key), ctj()),
    opts = list(...)
  )
  res <- con$post(body = tojun(body, TRUE), encode = "json")
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  switch(as, json = txt, list = jsl(txt), table = jsd(txt))
}
