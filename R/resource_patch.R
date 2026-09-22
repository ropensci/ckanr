#' Update a resource's metadata
#'
#' To point an existing resource at a new external URL, pass the link
#' through `rcurl`. If `x` also holds a `url` item, `rcurl` wins.
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Resource ID to update (required)
#' @param rcurl (character) New external URL of the resource, for example
#' an ArcGIS link. The function sends it as the resource `url` and sets
#' `url_type` to `link`, so CKAN stores a true external link. If `x` holds
#' its own `url_type` item, that value wins. Optional.
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("twist", author = "Alexandria"))
#'
#' # then create a resource
#' file <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
#' (xx <- resource_create(package_id = res$id, description = "my resource"))
#'
#' # Get a resource
#' res <- resource_show(xx$id)
#' res$description
#'
#' # Make some changes
#' x <- list(description = "My newer description")
#' z <- resource_patch(x, id = res)
#' z$description
#'
#' # Add an extra key:value pair
#' extra <- list("extra_key" = "my special value")
#' zz <- resource_patch(extra, id = res)
#' zz$extra_key
#'
#' # Point the resource at a new external URL
#' zzz <- resource_patch(list(), id = res, rcurl = "https://example.com/data.geojson")
#' zzz$url
#' }
resource_patch <- function(
  x, id, rcurl = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_resource(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  if (!is.null(rcurl)) {
    x$url <- rcurl
    if (is.null(x$url_type)) {
      x$url_type <- "link"
    }
  }
  payload <- jsonlite::toJSON(x, auto_unbox = TRUE, null = "null")
  res <- ckan_POST(
    url,
    method = "resource_patch",
    body = payload,
    key = key,
    headers = ctj(),
    opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_resource"),
    table = jsd(res)
  )
}
