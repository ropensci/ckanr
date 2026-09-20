#' List tags.
#'
#' @export
#'
#' @param query (character) Tag name query to search for. If you give a query,
#' the function returns only tags whose names contain this string.
#' @param vocabulary_id (character) ID or name of a vocabulary.
#' If you give a vocabulary, the function returns only tags that belong
#' to this vocabulary.
#' @param all_fields (logical) The function returns full tag dictionaries
#' instead of names. Default is `FALSE`.
#' @template args
#' @template key
#' @examples \dontrun{
#' # list all tags
#' tag_list()
#'
#' # search for a specific tag
#' tag_list(query = "aviation")
#'
#' # all fields
#' tag_list(all_fields = TRUE)
#'
#' # give back different data formats
#' tag_list("aviation", as = "json")
#' tag_list("aviation", as = "table")
#' }
tag_list <- function(
  query = NULL, vocabulary_id = NULL, all_fields = FALSE,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  args <- cc(list(
    query = query, vocabulary_id = vocabulary_id,
    all_fields = as_log(all_fields)
  ))
  res <- ckan_GET(url, "tag_list", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = lapply(jsl(res), as.ckan_tag),
    table = jsd(res)
  )
}
