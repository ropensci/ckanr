#' Ping a CKAN server to test that it's up or down.
#'
#' @export
#'
#' @template args
#' @examples \dontrun{
#' ping()
#' ping(as = "json")
#' }
ping <- function(url = get_default_url(), as = "logical", ...) {
  tryCatch({
    res <- ckan_POST(url, 'site_read', ...)
    switch(as, json = res, logical = jsd(res))
  }, error = function(e) FALSE)
}
