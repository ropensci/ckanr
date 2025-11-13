#' Get an activity stream of recently changed datasets on a site.
#'
#' @export
#' @template paging
#' @template args
#' @template key
#' @examples \dontrun{
#' changes()
#' changes(as = "json")
#' changes(as = "table")
#' }
changes <- function(
  offset = 0, limit = 31, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  # CKAN >= 2.10 deprecates this endpoint, fix expected from CKAN 2.12+
  ver <- floor(ckan_version(url)$version_num)
  if (ver > 29 && ver < 212) {
    stop("ckanr::changes() is not supported on CKAN >= 2.10", call. = FALSE)
  }
  args <- cc(list(offset = offset, limit = limit))
  res <- ckan_GET(url, "recently_changed_packages_activity_list", args,
    key = key, opts = list(...)
  )
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}
