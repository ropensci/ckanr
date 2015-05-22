#' Send an httr::POST request and handle the response
#'
#' @details This method is a thin wrapper around httr::POST, which is a wrapper
#' around RCurl::POST, which is a wrapper around curl.
#'
#' If the POST request requires authentication, a privileged CKAN API key has
#' to be supplied. The method does not default to \code{ckanr_settings}.
#' As the method is an internal method only, other functions of \code{ckanr}
#' may default to \code{ckanr_settings} for convenience of use.
#'
#' @keywords internal
#' @importFrom httr POST add_headers
#' @param url A CKAN base URL
#' @param method The GET method as part of the CKAN API URL
#' @param body The request body (a dictionary as named R list) (optional)
#' @param key A CKAN API key (optional)
#' @return The content of the response as text
ckan_POST <- function(url, method, body=NULL, key=NULL, ...){
  if (is.null(key)) {
    # no authentication
    if (is.null(body) || length(body) == 0) {
      res <- POST(file.path(url, ck(), method), ctj(), ...)
    } else {
      res <- POST(file.path(url, ck(), method), body = body, ...)
    }
  } else {
    # authentication
    api_key_header <- add_headers("X-CKAN-API-Key" = key)
    if (is.null(body) || length(body) == 0) {
      res <- POST(file.path(url, ck(), method), ctj(), api_key_header, ...)
    } else {
      res <- POST(file.path(url, ck(), method), body = body, api_key_header, ...)
    }
  }
  err_handler(res)
  content(res, "text")
}

#------------------------------------------------------------------------------#
# Helpers
#

cc <- function (l) Filter(Negate(is.null), l)
ck <- function() 'api/3/action'
as_log <- function(x){ stopifnot(is.logical(x)); if (x) 'true' else 'false' }
jsl <- function(x){ tmp <- jsonlite::fromJSON(x, FALSE); tmp$result }
jsd <- function(x){ tmp <- jsonlite::fromJSON(x); tmp$result }
ctj <- function() httr::content_type_json()


#' @importFrom httr http_condition
err_handler <- function(x) {
  if (x$status_code > 201) {
    obj <- try({
      err <- content(x)$error
      tmp <- err[names(err) != "__type"]
      errmsg <- paste(names(tmp), unlist(tmp[[1]]))
      list(err = err, errmsg = errmsg)
    }, silent = TRUE)
    if (class(obj) != "try-error") {
      stop(sprintf("%s - %s\n  %s",
                   x$status_code,
                   obj$err$`__type`,
                   obj$errmsg),
           call. = FALSE)
    } else {
      obj <- {
        err <- http_condition(x, "error")
        errmsg <- content(x, "text")
        list(err = err, errmsg = errmsg)
      }
      stop(sprintf("%s - %s\n  %s",
                   x$status_code,
                   obj$err[["message"]],
                   obj$errmsg),
           call. = FALSE)
    }
  }
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}
