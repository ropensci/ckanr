#' Datastore - search or get a dataset from CKAN datastore
#'
#' @export
#' @param resource_id (character) id or alias of the resource to be searched
#' against
#' @param filters (character) Matching conditions to select, for example
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
#' @param sort Field to sort on. You can specify ascending, for example score
#' desc, or descending, for example score asc. You can sort by two fields,
#' for example score desc, price asc. You can sort by a function, for example
#' sum(x_f, y_f) desc, which sorts by the sum of x_f and y_f in descending
#' order. (optional)
#' @param include_next_page (logical) If `TRUE`, CKAN 2.12+ returns a
#' `next_page` value with filters for fast keyset pagination. Ignored unless
#' records are sorted by the `_id` field (optional, default: `FALSE`).
#' See <https://docs.ckan.org/en/2.12/maintaining/datastore.html#search-pagination>.
#' @template args
#' @template key
#' @details From the help for this method "The datastore_search action allows
#' you to search data in a resource." If a DataStore resource belongs to a
#' private CKAN resource, you can read it only with access to that resource.
#' You must send the appropriate authorization.
#'
#' CKAN 2.12+ `filters` accept advanced syntax: range operations (`lt`,
#' `lte`, `gt`, `gte`, `eq`), lists mixing values and ranges, nested AND/OR
#' via lists, and `$or` groups (see
#' <https://docs.ckan.org/en/2.12/maintaining/datastore.html#filters>).
#' The `filters` argument passes through untouched, so both classic
#' (`{"key1": "a"}`) and advanced filters work. For large tables prefer
#' keyset pagination (`include_next_page = TRUE` with `sort = "_id asc"`)
#' over large `offset` values.
#'
#' If you set `plain=FALSE`, you enable the entire PostgreSQL *full text search
#' query language*. You can find a listing of all available resources at the
#' alias *table_metadata* full text search query language:
#' http://www.postgresql.org/docs/9.1/static/datatype-textsearch.html#DATATYPE-TSQUERY
#' @examples \dontrun{
#' ckanr_setup(url = "https://data.gov.au/")
#' rid <- "eef6a84b-ad44-446f-9cf9-fb5d135e3123"
#'
#' ds_search(resource_id = rid)
#' ds_search(resource_id = rid, as = "table")
#' ds_search(resource_id = rid, as = "json")
#'
#' ds_search(resource_id = rid, limit = 1, as = "table")
#' ds_search(resource_id = rid, q = "S*")
#'
#' # Return selected fields
#' ds_search(
#'   resource_id = rid,
#'   fields = c("name", "amount"),
#'   as = "table"
#' )
#'
#' # Match more than one field. CKAN applies the conditions together.
#' ds_search(
#'   resource_id = rid,
#'   filters = list(status = "active", category = "water"),
#'   fields = c("name", "status", "category"),
#'   as = "table"
#' )
#' }
ds_search <- function(
  resource_id = NULL, filters = NULL, q = NULL,
  plain = NULL, language = NULL, fields = NULL, offset = NULL,
  limit = NULL, sort = NULL, include_next_page = FALSE,
  url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  args <- cc(list(
    resource_id = resource_id, filters = filters, q = q,
    plain = plain, language = language, fields = fields,
    offset = offset, limit = limit, sort = sort,
    include_next_page = if (isTRUE(include_next_page)) TRUE else NULL
  ))
  con <- crul::HttpClient$new(
    url = file.path(notrail(url), "api/action/datastore_search"),
    headers = c(list(Authorization = key), ctj()),
    opts = list(...)
  )
  res <- con$post(query = args)
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  switch(as,
    json = txt,
    list = jsl(txt),
    table = jsd(txt)
  )
}
