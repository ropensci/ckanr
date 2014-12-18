#' Show a resource.
#'
#' @export
#'
#' @param id A resource ID
#' @template args
#' @examples \donttest{
#' resource_show(id = "e179e910-27fb-44f4-a627-99822af49ffa", as="table")
#' }
resource_show <- function(id, url = 'http://data.techno-science.ca', as='list', ...)
{
  res <- ckan_POST(url, 'resource_show', body = list(id=id), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

# res <- GET("http://data.nhm.ac.uk/api/3/action/resource_show?id=fefa4aca-61e0-4978-9507-040db59c1641&",
#     add_headers(`Authorization` = key))
# content(res)

# nhmbase <- "http://data.nhm.ac.uk"
# key <- "e0deeb4b-7d00-41a2-8679-8cb588718513"

# res <- GET("http://data.nhm.ac.uk/api/3/action/dashboard_activity_list",
#     add_headers(`Authorization` = key))
# content(res)
