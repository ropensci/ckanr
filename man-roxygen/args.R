#' @param url Base url to use. Default: \url{http://data.techno-science.ca}. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.
#' @param as (character) One of list (default), table, or json. Parsing with table option
#' uses \code{jsonlite::fromJSON(..., simplifyDataFrame = TRUE)}, which attempts to parse
#' data to data.frame's when possible, so the result can vary from a vector, list or
#' data.frame. (required)
#' @param ... Curl args passed on to \code{\link[crul]{verb-POST}} (optional)
