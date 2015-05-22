#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{setup_ckanr}} and \code{\link{get_default_url}}.
#' @param as (character) One of list (default), table, or json. Parsing with table option
#' uses \code{jsonlite::fromJSON(..., simplifyDataFrame = TRUE)}, which attempts to parse
#' data to data.frame's when possible, so the result can vary. (required)
#' @param ... Curl args passed on to \code{\link[httr]{POST}} (optional)
