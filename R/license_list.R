#' Return a dataset’s related items.
#'
#' @export
#' @param id (character) Package identifier.
#' @template args
#' @examples \donttest{
#' license_list()
#' license_list(as="table")
#' license_list(as="json")
#' }
license_list <- function(id, url = 'http://data.techno-science.ca', as="list", ...)
{
  res <- ckan_POST(url, 'license_list', ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
