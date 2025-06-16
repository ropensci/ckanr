#' Datastore - search or get a dataset from CKAN datastore
#'
#' @export
#' @param resource_id (character) id or alias of the resource to be searched
#' against
#' @param filters (character) matching conditions to select, e.g
#' `{"key1": "a", "key2": "b"}` (optional)
#' @param q (character) full text query (optional)
#' @param plain (character) treat as plain text query (optional, default:
#' `TRUE`)
#' @param language (character) language of the full text query (optional,
#' default: english)
#' @param fields (character) fields to return (optional, default: all fields
#' in original order)
#' @param offset (numeric) Where to start getting activity items from
#' (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return
#' (optional, default: 100)
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc,
#' price asc), or sort by a function (e.g., sum(x_f, y_f) desc, which sorts
#' by the sum of x_f and y_f in a descending order). (optional)
#' @template args
#' @template key
#' @details From the help for this method "The datastore_search action allows
#' you to search data in a resource. DataStore resources that belong to
#' private CKAN resource can only be read by you if you have access to the
#' CKAN resource and send the appropriate authorization."
#'
#' Setting `plain=FALSE` enables the entire PostgreSQL *full text search query
#' language*. A listing of all available resources can be found at the alias
#' *table_metadata* full text search query language:
#' http://www.postgresql.org/docs/9.1/static/datatype-textsearch.html#DATATYPE-TSQUERY
#' @examples \dontrun{
#' ckanr_setup(url = 'https://data.nhm.ac.uk/')
#' 
#' ds_search(resource_id = '8f0784a6-82dd-44e7-b105-6194e046eb8d')
#' ds_search(resource_id = '8f0784a6-82dd-44e7-b105-6194e046eb8d',
#'   as = "table")
#' ds_search(resource_id = '8f0784a6-82dd-44e7-b105-6194e046eb8d',
#'   as = "json")
#'
#' ds_search(resource_id = '8f0784a6-82dd-44e7-b105-6194e046eb8d', limit = 1,
#'   as = "table")
#' ds_search(resource_id = '8f0784a6-82dd-44e7-b105-6194e046eb8d', q = "a*")
#' }

ds_search <- function(resource_id = NULL, filters = NULL, q = NULL,
  plain = NULL, language = NULL, fields = NULL, offset = NULL,
  limit = NULL, sort = NULL, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  args <- cc(list(resource_id = resource_id, filters = filters,q = q,
                  plain = plain, language = language, fields = fields,
                  offset = offset, limit = limit, sort = sort))
  con <- crul::HttpClient$new(
    url = file.path(notrail(url), 'api/action/datastore_search'),
    headers = c(list(Authorization = key), ctj()),
    opts = list(...)
  )
  res <- con$post(query = args)
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  switch(as, json = txt, list = jsl(txt), table = jsd(txt))
}
