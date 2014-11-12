#' @param url Base url to use. Default: \url{http://data.techno-science.ca}
#' @param as (character) One of list (default), table, or json. Parsing with table option
#' uses \code{jsonlite::fromJSON(..., simplifyDataFrame = TRUE)}, which attempts to parse
#' data to data.frame's when possible, so the result can vary.
#' @param ... Curl args passed on to \code{\link[httr]{POST}}
