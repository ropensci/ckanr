#' Ping a CKAN server to test that it's up or down.
#'
#' @export
#'
#' @template args
#' @template key
#' @examples \dontrun{
#' ping()
#' ping(as = "json")
#' }
ping <- function(url = get_default_url(), key = get_default_key(),
  as = "logical", ...) {
  
  tryCatch({
    res <- ckan_GET(url, 'site_read', key = key, ...)
    switch(as, json = res, logical = jsd(res))
  }, error = function(e) FALSE)
}
