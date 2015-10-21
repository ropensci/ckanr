# httr helpers -----------------------
ckan_POST <- function(url, method, body = NULL, key = NULL, ...){
  ckan_VERB("POST", url, method, body, key, ...)
}

ckan_PATCH <- function(url, method, body = NULL, key = NULL, ...){
  ckan_VERB("PATCH", url, method, body, key, ...)
}

ckan_GET <- function(url, method, query = NULL, key = NULL, ...){
  ckan_VERB("GET", url, method, body = NULL, key, query = query, ...)
}

ckan_DELETE <- function(url, method, body = NULL, key = NULL, ...){
  ckan_VERB("DELETE", url, method, body, key, ...)
}

ckan_VERB <- function(verb, url, method, body, key, ...) {
  VERB <- getExportedValue("httr", verb)
  url <- sub("/$", "", url)
  if (is.null(key)) {
    # no authentication
    if (is.null(body) || length(body) == 0) {
      res <- VERB(file.path(url, ck(), method), ctj(), ...)
    } else {
      res <- VERB(file.path(url, ck(), method), body = body, ...)
    }
  } else {
    # authentication
    api_key_header <- add_headers("X-CKAN-API-Key" = key)
    if (is.null(body) || length(body) == 0) {
      res <- VERB(file.path(url, ck(), method), ctj(), api_key_header, ...)
    } else {
      res <- VERB(file.path(url, ck(), method), body = body, api_key_header, ...)
    }
  }
  err_handler(res)
  content(res, "text")
}

# GET fxn for fetch()
fetch_GET <- function(x, store, path, args = NULL, ...) {
  if (store == "session") {
    if (file_fmt(x) == "xls") {
      fmt <- file_fmt(x)
      dat <- NULL
      path <- paste0(path, ".xls")
      res <- GET(x, query = args, write_disk(path, TRUE), ...)
      path <- res$request$output$path
    } else if (file_fmt(x) %in% c("shp", "zip")) {
      fmt <- "shp"
      dat <- NULL
      path <- paste0(path, ".zip")
      res <- GET(x, query = args, write_disk(path, TRUE), ...)
      dir <- tempdir()
      unzip(path, exdir = dir)
      path <- list.files(dir, pattern = ".shp$", full.names = TRUE)
    } else {
      fmt <- file_fmt(x)
      path <- NULL
      res <- GET(x, query = args, ...)
      err_handler(res)
      dat <- content(res, "text")
    }
    list(store = store, fmt = fmt, data = dat, path = path)
  } else {
    # if (!file.exists(path)) stop("path does not exist", call. = FALSE)
    res <- GET(x, query = args, write_disk(path, TRUE), ...)
    list(store = store, fmt = file_fmt(x), data = NULL, path = res$request$output$path)
  }
}

file_fmt <- function(x) {
  gsub("\\.", "", strextract(x, "\\.[A-Za-z0-9]+$"))
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

#------------------------------------------------------------------------------#
# Helpers
cc <- function(l) Filter(Negate(is.null), l)
ck <- function() 'api/3/action'
as_log <- function(x){ stopifnot(is.logical(x)); if (x) 'true' else 'false' }
jsl <- function(x) jsonlite::fromJSON(x, FALSE)$result
jsd <- function(x) jsonlite::fromJSON(x)$result
ctj <- function() httr::content_type_json()

# fxn to attach classes
as_ck <- function(x, class) {
  structure(x, class = class)
}

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

asl <- function(z) {
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}

tojun <- function(x, unbox = TRUE) {
  jsonlite::toJSON(x, auto_unbox = unbox)
}

check4X <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  }
}
