#' Datastore - search or get a dataset from CKAN datastore
#'
#' @export
#' @param sql (character) A single SQL select statement. (required)
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(url = "https://data.gov.au/")
#' sql <- 'SELECT * from "eef6a84b-ad44-446f-9cf9-fb5d135e3123" LIMIT 2'
#' ds_search_sql(sql, as = "table")
#' sql2 <- 'SELECT "Dog","TRI" from "eef6a84b-ad44-446f-9cf9-fb5d135e3123" LIMIT 2'
#' ds_search_sql(sql2, as = "table")
#' }
ds_search_sql <- function(
  sql, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  con <- crul::HttpClient$new(
    url = file.path(notrail(url), "api/action/datastore_search_sql"),
    headers = c(list(Authorization = key), ctj()),
    opts = list(...)
  )
  res <- con$get(query = list(sql = sql))
  if (res$status_code > 299) {
    res$raise_for_ct_json()
    if (grepl("html", res$response_headers$`content-type`)) res$raise_for_status()
    stop(res$parse("UTF-8"))
  }
  txt <- res$parse("UTF-8")
  switch(as,
    json = txt,
    list = jsl(txt),
    table = jsd(txt)
  )
}
