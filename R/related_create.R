#' Create a related item
#'
#' @export
#'
#' @param id (character) ID of the package. You add the related item
#' to this package. The value must be an alphanumeric string. Required.
#' @param title (character) Title of the related item. Required.
#' @param type (character) Type of the related item. The value is one of API,
#' application, idea, news article, paper, post or visualization. Required.
#' @param description (character) Description of the related item. Optional.
#' @param related_id (character) ID to assign to the related item.
#' If the value is blank, the function assigns an ID. Optional.
#' @param related_url (character) URL for the related item.
#' Optional.
#' @param image_url (character) URL of an image for the related item. Optional.
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("hello-mars"))
#'
#' # create a related item
#' related_create(res, title = "asdfdaf", type = "idea")
#'
#' # pipe operations together
#' package_create("foobbbbbarrrr") %>%
#'   related_create(
#'     title = "my resource",
#'     type = "visualization"
#'   )
#' }
related_create <- function(
  id, title, type, description = NULL,
  related_id = NULL, related_url = NULL, image_url = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("related_create", url = url, key = key)
  id <- as.ckan_package(id, url = url, key = key)
  body <- cc(list(
    dataset_id = id$id, title = title,
    type = type, url = related_url,
    description = description, id = related_id,
    image_url = image_url
  ))
  res <- ckan_POST(url, "related_create",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), opts = list(...), encode = "json"
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_related"),
    table = jsd(res)
  )
}
