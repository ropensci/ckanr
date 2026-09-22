#' Add a new table to a datastore
#'
#' BEWARE: This function does not work yet.
#'
#' @export
#' @param resource_id (string) Resource id that stores the data.
#' @param force (logical) To edit a read-only resource, set to `TRUE`.
#' Default: `FALSE`
#' @param resource (dictionary) Resource dictionary for
#' [resource_create()]. Use it instead of `resource_id` (optional)
#' @param aliases (character) Names for read only aliases of the resource.
#' (optional)
#' @param fields (list) Fields/columns and their extra metadata. (optional)
#' @param records (list) The data, for example: `[{"dob": "2005", "some_stuff":
#' ["a", "b"]}]` (optional)
#' @param primary_key (character) Fields that represent a unique key (optional)
#' @param indexes (character) Indexes on table (optional)
#' @param include_records (logical) If `TRUE`, CKAN 2.12+ returns the actual
#' inserted records (including `_id` values and transformations) in the
#' response. Default: `FALSE`. See
#' <https://github.com/ckan/ckan/pull/8684>. Note: bulk inserts with
#' `include_records = TRUE` can hit a server-side error on CKAN 2.12.0; use
#' a single record or [ds_upsert()] with `include_records = TRUE` instead
#' when affected.
#' @template key
#' @template args
#' @references http://bit.ly/ds_create
#' @examples \dontrun{
#' ckanr_setup(
#'   url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key")
#' )
#'
#' # create a package
#' (res <- package_create("foobarrrrr", author = "Jane Doe"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(
#'   package_id = res$id,
#'   description = "my resource",
#'   name = "bears",
#'   upload = file,
#'   rcurl = "http://google.com"
#' ))
#' ds_create(resource_id = xx$id, records = iris, force = TRUE)
#' resource_show(xx$id)
#' }
ds_create <- function(
  resource_id = NULL, resource = NULL, force = FALSE,
  aliases = NULL, fields = NULL, records = NULL, primary_key = NULL,
  indexes = NULL, include_records = FALSE,
  url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  body <- cc(list(
    resource_id = resource_id, resource = resource, force = force,
    aliases = aliases, fields = fields, records = records,
    primary_key = primary_key, indexes = indexes,
    include_records = if (isTRUE(include_records)) TRUE else NULL
  ))
  headers <- c(auth_headers(key), ctj())
  con <- crul::HttpClient$new(file.path(url, "api/action/datastore_create"),
    headers = headers,
    opts = list(...)
  )
  res <- con$post(body = tojun(body, TRUE), encode = "json")
  err_handler(res)
  txt <- res$parse("UTF-8")
  switch(as,
    json = txt,
    list = jsl(txt),
    table = jsd(txt)
  )
}
