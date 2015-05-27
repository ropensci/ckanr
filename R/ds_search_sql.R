#' Datastore - search or get a dataset from CKRAN datastore
#'
#' @export
#'
#' @param sql (character) A single SQL select statement. (required)
#' @template args
#' @examples \dontrun{
#' url <- 'http://demo.ckan.org/'
#' sql <- 'SELECT * from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
#' ds_search_sql(sql, url = url, as = "table")
#' sql2 <- 'SELECT "Species","Genus","Family" from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
#' ds_search_sql(sql2, url = url, as = "table")
#' }

ds_search_sql <- function(sql, url = get_default_url(), as = 'list', ...) {
  res <- POST(file.path(url, '/api/action/datastore_search_sql'), ctj(),
              query=list(sql = sql), ...)
  res <- content(res, "text")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
