cc <- function (l) Filter(Negate(is.null), l)

ck <- function() 'api/3/action'

as_log <- function(x){
  stopifnot(is.logical(x))
  if (x) 'true' else 'false'
}

jsl <- function(x){
  tmp <- jsonlite::fromJSON(x, FALSE)
  tmp$result
}
jsd <- function(x){
  tmp <- jsonlite::fromJSON(x)
  tmp$result
}

ckan_POST <- function(url, method, body=NULL, ...){
  api_key_header <- api_key()
  if (is.null(api_key_header)) {
    # no authentication
    if (is.null(body) || length(body) == 0) {
      res <- POST(file.path(url, ck(), method), ctj(), ...)
    } else {
      res <- POST(file.path(url, ck(), method), body = body, ...)
    }
  } else {
    # authentication
    if (is.null(body) || length(body) == 0) {
      res <- POST(file.path(url, ck(), method), ctj(), api_key_header, ...)
    } else {
      res <- POST(file.path(url, ck(), method), body = body, api_key_header, ...)
    }
  }
  err_handler(res)
  content(res, "text")
}

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
      stop(sprintf("%s - %s\n  %s", x$status_code, obj$err$`__type`, obj$errmsg), call. = FALSE)
    } else {
      obj <- {
        err <- http_condition(x, "error")
        errmsg <- content(x, "text")
        list(err = err, errmsg = errmsg)
      }
      stop(sprintf("%s - %s\n  %s", x$status_code, obj$err[["message"]], obj$errmsg), call. = FALSE)
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

ctj <- function() httr::content_type_json()
