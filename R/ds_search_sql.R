#' Datastore - search or get a dataset from CKRAN datastore
#'
#' @export
#'
#' @param sql (character) A single SQL select statement. (required)
#' @template args
#' @template key
#' @examples \dontrun{
#' url <- 'https://demo.ckan.org/'
#' sql <- 'SELECT * from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
#' ds_search_sql(sql, url = url, as = "table")
#' sql2 <- 'SELECT "Species","Genus","Family" from "f4129802-22aa-4437-b9f9-8a8f3b7b2a53" LIMIT 2'
#' ds_search_sql(sql2, url = url, as = "table")
#' }
#' @importFrom httr status_code

ds_search_sql <- function(sql, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- httr::GET(file.path(notrail(url), 'api/action/datastore_search_sql'), ctj(),
              query = list(sql = sql), add_headers(Authorization = key), ...)
  if (status_code(res) > 299) {
    if (grepl("html", res$headers$`content-type`)) httr::stop_for_status(res)
    stop(httr::content(res, "text", encoding = "UTF-8"))
  }
  res <- httr::content(res, "text", encoding = "UTF-8")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
