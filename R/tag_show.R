#' Show a tag.
#'
#' @export
#'
#' @param id (character) The name or id of the tag
#' @param include_datasets include a list of up to 1000 of the tag's datasets.
#'  Limit 1000 datasets, use \code{\link{package_search}} for more.
#'  (optional, default: False)
#' @template args
#' @examples \dontrun{
#' tag_show('Aviation')
#' tag_show('Aviation', as = 'json')
#' tag_show('Aviation', as = 'table')
#' }
tag_show <- function(id, include_datasets = FALSE, url = get_default_url(),
                     as = 'list', ...) {
  res <- ckan_POST(url, 'tag_show',
                   body = list(id = id, include_datasets = include_datasets), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
