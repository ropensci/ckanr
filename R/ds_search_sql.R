#' Datastore - search or get a dataset from CKRAN datastore
#'
#' @export
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

ds_search_sql <- function(sql, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  con <- crul::HttpClient$new(
    url = file.path(notrail(url), 'api/action/datastore_search_sql'),
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
  switch(as, json = txt, list = jsl(txt), table = jsd(txt))
}
