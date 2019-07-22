#' Show a related item
#'
#' @export
#'
#' @param id (character) Related item identifier.
#' @template args
#' @template key
#' @details By default the help and success slots are dropped, and only the
#'   result slot is returned. You can request raw json with \code{as = 'json'}
#'   then parse yourself to get the help slot.
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package and a related item
#' res <- package_create("hello-pluto2") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization")
#'
#' # show the related item
#' related_show(res)
#' related_show(res$id)
#'
#' # get data back in different formats
#' related_show(res, as = 'json')
#' related_show(res, as = 'table')
#' }
related_show <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  id <- as.ckan_related(id, url = url)
  res <- ckan_GET(url, 'related_show', list(id = id$id), key = key, ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_related"),
    table = jsd(res))
}
