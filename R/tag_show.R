#' Show a tag.
#'
#' @export
#'
#' @param id (character) The name or id of the tag
#' @template args
#' @examples \donttest{
#' tag_show('Aviation')
#' tag_show('Aviation', as='json')
#' tag_show('Aviation', as='table')
#' }
tag_show <- function(id, url = 'http://data.techno-science.ca', as='list', ...)
{
  res <- ckan_POST(url, 'tag_show', body = list(id = id), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
