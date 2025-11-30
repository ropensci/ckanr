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
ping <- function(
  url = get_default_url(), key = get_default_key(),
  as = "logical", ...
) {
  tryCatch(
    {
      res <- ckan_GET(url, "status_show", key = key, opts = list(...))
      switch(as,
        json = res,
        logical = isTRUE(jsonlite::fromJSON(res)$success)
      )
    },
    error = function(e) FALSE
  )
}
