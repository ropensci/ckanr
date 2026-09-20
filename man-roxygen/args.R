#' @param url Base URL to use. Default: https://demo.ckan.org/. See
#' also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.
#' @param as (character) One of list (default), table, or json. Parsing with
#' the table option uses \code{jsonlite::fromJSON(..., simplifyDataFrame = TRUE)},
#' which attempts to parse data to data.frame's when possible. The result
#' can vary from a vector, list or data.frame. (required)
#' @param ... Extra curl arguments. The function passes them to \code{\link[crul]{verb-POST}} (optional)
