#' Datastore - search or get a dataset from CKRAN datastore
#'
#' @export
#'
#' @param resource_id (character) id or alias of the resource to be searched against
#' @param filters (character) matching conditions to select, e.g {"key1": "a", "key2": "b"}
#' (optional)
#' @param q (character) full text query (optional)
#' @param plain (character) treat as plain text query (optional, default: TRUE)
#' @param language (character) language of the full text query (optional, default: english)
#' @param fields (character) fields to return (optional, default: all fields in original order)
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 100)
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc),
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of
#' x_f and y_f in a descending order). (optional)
#' @template args
#' @details From the help for this method "The datastore_search action allows you to search data
#' in a resource. DataStore resources that belong to private CKAN resource can only be
#' read by you if you have access to the CKAN resource and send the appropriate authorization."
#'
#' Setting \code{plain=FALSE} enables the entire PostgreSQL \emph{full text search query language}.
#' A listing of all available resources can be found at the alias \emph{table_metadata}
#' full text search query language:
#' \url{http://www.postgresql.org/docs/9.1/static/datatype-textsearch.html#DATATYPE-TSQUERY}.
#' @examples \dontrun{
#' url <- 'http://demo.ckan.org/'
#' ds_search(resource_id = 'f4129802-22aa-4437-b9f9-8a8f3b7b2a53', url = url)
#' ds_search(resource_id = 'f4129802-22aa-4437-b9f9-8a8f3b7b2a53', url = url, as = "table")
#' ds_search(resource_id = 'f4129802-22aa-4437-b9f9-8a8f3b7b2a53', url = url, as = "json")
#'
#' ds_search(resource_id = 'f4129802-22aa-4437-b9f9-8a8f3b7b2a53', url = url, limit = 1, as = "table")
#' ds_search(resource_id = 'f4129802-22aa-4437-b9f9-8a8f3b7b2a53', url = url, q = "a*")
#' }

ds_search <- function(resource_id = NULL, filters = NULL, q = NULL, plain = NULL,
                      language = NULL, fields = NULL, offset = NULL,
                      limit = NULL, sort = NULL,
                      url = get_default_url(), as = 'list', ...) {
  args <- cc(list(resource_id = resource_id, filters = filters,q = q,
                  plain = plain, language = language, fields = fields,
                  offset = offset, limit = limit, sort = sort))
  res <- POST(file.path(url, '/api/action/datastore_search'), ctj(),
              query = args, ...)
  res <- content(res, "text")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
