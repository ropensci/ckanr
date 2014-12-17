#' Ping a CKAN server to test that it's up or down.
#'
#' @export
#'
#' @param offset (numeric) Where to start getting activity items from (optional, default: 0)
#' @param limit (numeric) The maximum number of activities to return (optional, default: 31)
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}
#' @param as (character) One of logical (default) or json. logical returns a logical, json
#' returns json.
#' @param ... Curl args passed on to \code{\link[httr]{POST}}
#' @examples \donttest{
#' ping()
#' ping(as="json")
#' }
ping <- function(url = 'http://data.techno-science.ca', as="logical", ...)
{
  res <- ckan_POST(url, 'site_read', ...)
  switch(as, json = res, logical = jsd(res))
}
