#' Upsert data to a datastore
#'
#' @export
#' @param resource_id (string) Resource id that the data is going to be stored
#'   against.
#' @param force (logical) Set to \code{TRUE} to edit a read-only resource.
#'   Default: FALSE
#' @param method (string) Set to \code{insert}, \code{upsert} or \code{update}
#'   Default: 'upsert'
#' @param records (list) The data, eg: \code{[{"dob": "2005", "some_stuff":
#'   ["a", "b"]}]} (optional)
#' @template key
#' @template args
#' @references \url{http://bit.ly/1G9cnBl}

ds_upsert <- function(resource_id = NULL, force = FALSE,
                      method = 'upsert', records = NULL,
                      key = get_default_key(),
                      url = get_default_url(), as = 'list', ...) {

  body <- cc(list(resource_id = resource_id, force = force,
                  fields = fields, records = records))
  res <- POST(file.path(url, 'api/action/datastore_upsert'),
              add_headers(Authorization = key),
              body = tojun(body, TRUE),
              encode = "json", ctj(), ...)
  stop_for_status(res)
  res <- content(res, "text", encoding = "UTF-8")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

convert <- function(x){ if (!is.null(x)) { jsonlite::toJSON(x) } else { NULL } }
