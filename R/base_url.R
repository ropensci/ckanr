#' Set/get the default CKAN URL
#'
#' The default CKAN URL is set to the \href{http://data.techno-science.ca}{CSTMC open data portal}
#' when the \code{ckanr} package is loaded. This base URL is then passed to
#' \code{ckanr} functions using \code{get_ckan_url()}.
#'
#' @param url Base url to use. Default: \url{http://data.techno-science.ca}.
#' @return sets the \code{ckanr.default.url} option with \code{\link{options}}.
#' @examples
#' \dontrun{
#' get_ckanr_url()
#' set_ckanr_url("https://data.gov.au")
#' get_ckanr_url()
#' }
#' @export

set_ckanr_url <- function (url = "http://data.techno-science.ca")
  options(ckanr.default.url = url)

#' @rdname set_ckanr_url
#' @export

get_ckanr_url <- function () getOption("ckanr.default.url")
