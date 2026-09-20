#' Get information on a CKAN server
#'
#' @export
#' @param ... Curl args passed on to [crul::verb-GET] (optional)
#' @return for `ckan_info` a list with many slots with various info.
#' for `ckan_version`, list of length two, with actual version as character,
#' and another with version converted to numeric (any dots or letters removed)
#' @examples \dontrun{
#' ckan_info()
#' ckan_info(servers()[5])
#'
#' ckan_version(servers()[5])
#' }
ckan_info <- function(url = get_default_url(), ...) {
  ## FIX for newer CKAN instances
  ## FIXME: may need to try this and the above api route for older versions
  jsonlite::fromJSON(ckan_GET(url, "status_show", opts = list(...)))$result
}

#' @export
#' @param url Base url to use. Default: <https://data.ontario.ca>. See
#' also [ckanr_setup()] and [get_default_url()]. (required)
#' @rdname ckan_info
ckan_version <- function(url = get_default_url(), ...) {
  ver <- ckan_info(url, ...)$ckan_version
  nn <- parse_version_number(ver)
  list(version = ver, version_num = nn)
}

parse_version_number <- function(x) {
  # Returns NA for missing/malformed input instead of warning or "2NA".
  # Encoding: CKAN "2.3.5" -> 23.5, "2.6.1" -> 26.1, "2.9" -> 29,
  # "2.11.2" -> 211.2, "3.0.0" -> 30.0. Callers compare against
  # 23.5 (2.3.5), 26.1 (2.6.1) and 29.0 (2.9); see package_search().
  if (is.null(x) || length(x) != 1L || !is.character(x) || is.na(x)) {
    return(NA_real_)
  }
  version_components <- unlist(regmatches(x, gregexpr("[[:digit:]]+", x)))
  if (length(version_components) < 2) {
    return(NA_real_)
  }
  major_minor <- paste0(version_components[1:2], collapse = "")
  if (length(version_components) == 2) {
    as.numeric(major_minor)
  } else {
    patch_etc <- paste0(version_components[-c(1:2)], collapse = "")
    as.numeric(paste0(major_minor, ".", patch_etc))
  }
}
