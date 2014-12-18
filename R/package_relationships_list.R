#' Return a list of the site’s user accounts.
#'
#' @export
#' @param q (character) Restrict the users returned to those whose names contain a string
#' @param order_by (character) Which field to sort the list by (optional, default: 'name')
#' @template args
#' @examples \donttest{
#' id="e179e910-27fb-44f4-a627-99822af49ffa"
#' id2="a4233ee2-a675-4c6a-803c-177e6ab220c0"
#' package_relationships_list(id, id2)
#' package_relationships_list(as="table")
#' package_relationships_list(as="json")
#' }
package_relationships_list <- function(id, id2, url = 'http://data.techno-science.ca', as="list", ...)
{
  body <- cc(list(id=id, id2=id2))
  res <- ckan_POST(url, 'package_relationships_list', body=body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
