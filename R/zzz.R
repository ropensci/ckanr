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
  if (is.null(body)) {
    res <- POST(file.path(url, ck(), method), ctj(), ...)
  } else {
    res <- POST(file.path(url, ck(), method), body = body, ...)
  }
  err_handler(res)
  content(res, "text")
}

#' @importFrom httr http_condition
err_handler <- function(x) {
  if (x$status_code > 201) {
    err <- http_condition(x, "error")
    errmssg <- content(x, "text")
    stop(sprintf("%s - %s\n  %s", x$status_code, err[["message"]], errmssg), call. = FALSE)
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

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.ckanr <- list(ckanr.default.url = "http://data.techno-science.ca")
  toset <- !(names(op.ckanr) %in% names(op))
  if(any(toset)) options(op.ckanr[toset])
  invisible()
}
