#' Return a list of the IDs of the site's revisions.
#'
#' @export
#' @template args
#' @template key
#' @examples \dontrun{
#' revision_list()
#' revision_list(as = "table")
#' revision_list(as = "json")
#' }
revision_list <- function(url = get_default_url(), key = get_default_key(),
  as = "list", ...) {

  res <- ckan_GET(url, 'revision_list', key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
