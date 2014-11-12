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

ckan_POST <- function(url, method, body, ...){
  res <- POST(file.path(url, ck(), method), body = body, ...)
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
