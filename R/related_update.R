#' Update a related item
#'
#' @export
#'
#' @inheritParams related_create
#' @param id (character) id of related item to update. This should be an
#' alphanumeric string. Required.
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package and related item
#' res <- package_create("hello-saturn2") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization")
#'
#' # update the related item
#' related_update(res, title = "her resource", type = "idea")
#' }
related_update <- function(id, title, type, description = NULL,
  related_id = NULL, related_url = NULL, image_url = NULL,
  key = get_default_key(), url = get_default_url(), as = 'list', ...) {

  id <- as.ckan_related(id, url = url)
  body <- cc(list(id = id$id, title = title,
                  type = type, url = related_url,
                  description = description, id = related_id,
                  image_url = image_url))
  res <- ckan_POST(url, 'related_update',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_related"), table = jsd(res))
}
