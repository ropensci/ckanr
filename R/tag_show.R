#' Show a tag.
#'
#' @export
#'
#' @param id (character) Name or ID of the tag.
#' @param include_datasets Include a list of up to 1000 datasets of the tag.
#' The limit is 1000 datasets. Use [package_search()] for more.
#' Optional. Default is `FALSE`.
#' @template args
#' @template key
#' @examples \dontrun{
#' # get tags with tag_list()
#' tags <- tag_list()
#' tags[[30]]$id
#'
#' # show a tag
#' (x <- tag_show(tags[[30]]$id))
#'
#' # give back different data formats
#' tag_show(tags[[30]]$id, as = "json")
#' tag_show(tags[[30]]$id, as = "table")
#' }
tag_show <- function(
  id, include_datasets = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_tag(id, url = url)
  res <- ckan_GET(url, "tag_show",
    query = list(id = id$id, include_datasets = include_datasets), key = key,
    opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_tag"),
    table = jsd(res)
  )
}
