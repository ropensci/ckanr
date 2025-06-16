#' Search tags.
#'
#' @export
#'
#' @param query (character) A tag name query to search for, if given only tags
#' whose names contain this string will be returned; one or more search
#' strings
#' @param vocabulary_id (character) The id or name of a vocabulary,
#' if give only tags that belong to this vocabulary will be returned
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' tag_search(query = 'ta')
#' tag_search(query = c('ta', 'al'))
#'
#' # different formats back
#' tag_search(query = 'ta', as = 'json')
#' tag_search(query = 'ta', as = 'table')
#' }
tag_search <- function(query = NULL, vocabulary_id = NULL,
  offset = 0, limit = 31, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  args <- cc(list(vocabulary_id = vocabulary_id, offset = offset,
    limit = limit))
  args <- c(args, handle_many(query))
  res <- ckan_GET(url, 'tag_search', args, key = key, opts = list(...))
  switch(as, json = res, list = lapply(jsl(res)$results, as.ckan_tag),
    table = jsd(res))
}
