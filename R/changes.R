#' Get an activity stream of recently changed datasets on a site.
#'
#' @export
#' @template paging
#' @template args
#' @examples \dontrun{
#' changes()
#' changes(as = 'json')
#' changes(as = 'table')
#' }
changes <- function(offset = 0, limit = 31,
                    url = get_default_url(), as ='list', ...) {
  body <- cc(list(offset = offset, limit = limit))
  res <- ckan_POST(url, 'recently_changed_packages_activity_list', body = body,
                   ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
