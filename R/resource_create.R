#' Create a resource
#'
#' @export
#'
#' @param package_id (character) ID of the package. You add the resource
#' to this package. The value must be an alphanumeric string. Required.
#' @param rcurl (character) URL of the resource. Required.
#' @param description (character) Description of the resource. Optional. Required.
#' @param name (character) Name of the resource. Optional. Required.
#' @param revision_id (character) Revision ID. Optional.
#' @param format (character) Format. Optional.
#' @param hash (character) Hash. Optional.
#' @param resource_type (character) Resource type. Optional.
#' @param mimetype (character) MIME type. Optional.
#' @param mimetype_inner (character) Inner MIME type. Optional.
#' @param webstore_url (character) Webstore URL. Optional.
#' @param cache_url (character) Cache URL. Optional.
#' @param size (integer) Size. Optional.
#' @param created (character) ISO date string. Optional.
#' @param last_modified (character) ISO date string. Optional.
#' @param cache_last_updated (character) ISO date string. Optional.
#' @param webstore_last_updated (character) ISO date string. Optional.
#' @param upload (character) Path to a local file. Optional.
#' @param extras (list) Extra metadata fields of the resource. Optional.
#' @param http_method (character) HTTP method (verb) to use.
#' The value is one of "GET" or "POST". Default is "GET".
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(
#'   url = "https://demo.ckan.org/",
#'   key = getOption("ckan_demo_key")
#' )
#'
#' # create a package
#' (res <- package_create("foobarrrr", author = "Jane Doe"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(
#'   package_id = res$id,
#'   description = "my resource",
#'   name = "bears",
#'   upload = file,
#'   extras = list(species = "grizzly"),
#'   rcurl = "http://google.com"
#' ))
#'
#' package_create("foobbbbbarrrr") |>
#'   resource_create(
#'     description = "my resource",
#'     name = "bearsareus",
#'     upload = file,
#'     extras = list(my_extra = "some value"),
#'     rcurl = "http://google.com"
#'   )
#' }
resource_create <- function(
  package_id = NULL, rcurl = NULL,
  revision_id = NULL, description = NULL, format = NULL, hash = NULL,
  name = NULL, resource_type = NULL, mimetype = NULL,
  mimetype_inner = NULL, webstore_url = NULL, cache_url = NULL, size = NULL,
  created = NULL, last_modified = NULL, cache_last_updated = NULL,
  webstore_last_updated = NULL, upload = NULL, extras = NULL, http_method = "GET",
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_package(package_id, url = url, key = key, http_method = http_method)
  body <- cc(list(
    package_id = id$id, url = rcurl, revision_id = revision_id,
    description = description, format = format, hash = hash,
    name = name, resource_type = resource_type, mimetype = mimetype,
    mimetype_inner = mimetype_inner, webstore_url = webstore_url,
    cache_url = cache_url, size = size, created = created,
    last_modified = last_modified,
    cache_last_updated = cache_last_updated,
    webstore_last_updated = webstore_last_updated,
    upload = upfile(upload)
  ))
  body <- c(body, extras)
  res <- ckan_POST(url, "resource_create",
    body = body, key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_resource"),
    table = jsd(res)
  )
}

upfile <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    crul::upload(x)
  }
}
