#' @title Update a group
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Package identifier
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # First, create a group
#' grp <- group_create("water-bears")
#' group_show(grp$id)
#'
#' ## update just chosen things
#' # Make some changes
#' x <- list(description = "A group about water bears and people that love them")
#'
#' # Then update the packge
#' group_update(x, id = grp$id)
#' }
group_update <- function(x, id, url = get_default_url(), key = get_default_key(),
                           as = 'list', ...) {
  if (class(x) != "list") {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id
  res <- ckan_POST(url, method = 'group_update',
                   body = tojun(x, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
