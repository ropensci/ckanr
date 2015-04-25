cc <- function (l) Filter(Negate(is.null), l)

ck <- function() 'api/3/action'

as_log <- function(x){
  stopifnot(is.logical(x))
  if(x) 'true' else 'false'
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
    res <- if(is.null(body)) POST(file.path(url, ck(), method), ctj(), ...) else POST(file.path(url, ck(), method), body = body, ...)
  } else {
    # authentication
    res <- if(is.null(body)) POST(file.path(url, ck(), method), ctj(), api_key_header, ...) else POST(file.path(url, ck(), method), body = body, api_key_header, ...)
  }
  stop_for_status(res)
  content(res, "text")
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
