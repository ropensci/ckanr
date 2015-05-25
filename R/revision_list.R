#' Return a list of the IDs of the site's revisions.
#'
#' @export
#' @template args
#' @examples \dontrun{
#' revision_list()
#' revision_list(as = "table")
#' revision_list(as = "json")
#' }
revision_list <- function(url = get_default_url(), as = "list", ...) {
  res <- ckan_POST(url, 'revision_list', ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
