#' Show a related item
#'
#' @export
#'
#' @param id (character) Package identifier.
#' @template args
#' @details By default the help and success slots are dropped, and only the
#'   result slot is returned. You can request raw json with \code{as = 'json'}
#'   then parse yourself to get the help slot.
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package and a related item
#' res <- package_create("hello-pluto") %>%
#'    related_create(title = "my resource",
#'                   type = "visualization")
#'
#' # show the related item
#' related_show(res$id)
#'
#' # get data back in different formats
#' related_show(res$id, as = 'json')
#' related_show(res$id, as = 'table')
#' }
related_show <- function(id, url = get_default_url(), as = 'list', ...) {
  res <- ckan_POST(url, 'related_show', body = tojun(list(id = id), TRUE), key = NULL,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
