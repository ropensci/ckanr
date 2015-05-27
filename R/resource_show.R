#' Show a resource.
#'
#' @export
#'
#' @param id (character) Resource identifier.
#' @template args
#' @examples \dontrun{
#' resource_show(id = "e179e910-27fb-44f4-a627-99822af49ffa", as = "table")
#' resource_show(id = "05ff2255-c38a-40c9-b657-4ccb55ab2feb",
#'               url = "http://data.nhm.ac.uk")
#' }
resource_show <- function(id, url = get_default_url(), as = 'list', ...) {
  res <- ckan_POST(url, 'resource_show', body = list(id = id), ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
