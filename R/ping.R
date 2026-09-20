#' Ping a CKAN server to test that it's up or down.
#'
#' @export
#'
#' @template args
#' @template key
#' @param as (character) One of "logical" (default) or "json". With
#'   `as = "logical"` failures return `FALSE`; with `as = "json"` failures
#'   signal an error instead of returning a non-JSON logical.
#' @examples \dontrun{
#' ping()
#' ping(as = "json")
#' }
ping <- function(
  url = get_default_url(), key = get_default_key(),
  as = "logical", ...
) {
  as <- match.arg(as, c("logical", "json"))
  tryCatch(
    {
      res <- ckan_GET(url, "status_show", key = key, opts = list(...))
      switch(as,
        json = res,
        logical = isTRUE(jsonlite::fromJSON(res)$success)
      )
    },
    error = function(e) {
      if (identical(as, "logical")) FALSE else stop(conditionMessage(e), call. = FALSE)
    }
  )
}
