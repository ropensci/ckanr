#' Show a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @template args
#' @examples \dontrun{
#' resource_show(id = "e179e910-27fb-44f4-a627-99822af49ffa", as="table")
#' resource_show(id = "05ff2255-c38a-40c9-b657-4ccb55ab2feb", url = "http://data.nhm.ac.uk")
#' }
resource_show <- function(id, url = get_ckanr_url(), as = 'list', key = NULL, ...) {
  res <- ckan_POST(url, 'resource_show', body = list(id = id), key = key, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

# nhmbase <- "http://data.nhm.ac.uk"
# key <- "e0deeb4b-7d00-41a2-8679-8cb588718513"

# res <- GET("http://data.nhm.ac.uk/api/3/action/dashboard_activity_list",
#     add_headers(`Authorization` = key))
# content(res)
