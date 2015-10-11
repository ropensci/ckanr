#' Create a related item
#'
#' @export
#'
#' @param id (character) id of package that the related item should be added to.
#' This should be an alphanumeric string. Required.
#' @param title (character) Title of the related item. Required.
#' @param type (character) The type of the related item. One of API, application,
#' idea, news article, paper, post or visualization. Required.
#' @param description (character) description (optional). Optional
#' @param related_id (character) An id to assign to the related item. If blank, an
#' ID will be assigned for you. Optional
#' @param related_url (character) A url to associated with the related item. Optional
#' @param image_url (character) A url to associated image. Optional
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' (res <- package_create("hello-mars"))
#'
#' # create a related item
#' related_create(res, title = "asdfdaf", type = "idea")
#'
#' # pipe operations together
#' package_create("foobbbbbarrrr") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization")
#' }
related_create <- function(id, title, type, description = NULL,
  related_id = NULL, related_url = NULL, image_url = NULL,
  key = get_default_key(), url = get_default_url(), as = 'list', ...) {

  id <- as.ckan_package(id, url = url)
  body <- cc(list(dataset_id = id$id, title = title,
                  type = type, url = related_url,
                  description = description, id = related_id,
                  image_url = image_url))
  res <- ckan_POST(url, 'related_create',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_related"), table = jsd(res))
}
