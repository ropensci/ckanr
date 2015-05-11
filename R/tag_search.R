#' List tags.
#'
#' @export
#'
#' @param query (character) A tag name query to search for, if given only tags whose names contain
#' this string will be returned
#' @param vocabulary_id (character) The id or name of a vocabulary, if give only tags that belong
#' to this vocabulary will be returned
#' @template paging
#' @template args
#' @examples \dontrun{
#' tag_search('aviation')
#' tag_search('aviation', as='json')
#' tag_search('aviation', as='table')
#' }
tag_search <- function(query = NULL, vocabulary_id = NULL, offset = 0, limit = 31,
  url = get_ckanr_url(), as = 'list', ...) {

  body <- cc(list(query = query, vocabulary_id = vocabulary_id, offset = offset, limit = limit))
  res <- ckan_POST(url, 'tag_search', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
