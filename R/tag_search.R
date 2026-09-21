#' Search tags.
#'
#' @export
#'
#' @param query (character) Tag name query to search for. If you give a query,
#' the function returns only tags whose names contain this string. The value
#' is one or more search strings.
#' @param vocabulary_id (character) ID or name of a vocabulary.
#' If you give a vocabulary, the function returns only tags that belong
#' to this vocabulary.
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' tag_search(query = "ta")
#' tag_search(query = c("ta", "al"))
#'
#' # different formats back
#' tag_search(query = "ta", as = "json")
#' tag_search(query = "ta", as = "table")
#' }
tag_search <- function(
  query = NULL, vocabulary_id = NULL,
  offset = 0, limit = 31, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  args <- cc(list(
    vocabulary_id = vocabulary_id, offset = offset,
    limit = limit
  ))
  args <- c(args, handle_many(query))
  res <- ckan_GET(url, "tag_search", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = lapply(jsl(res)$results, as.ckan_tag),
    table = jsd(res)
  )
}
