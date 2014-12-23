#' Datastore - create a datastore
#'
#' @export
#'
#' @template args
#' @examples \donttest{
#' ds_create(id='6b30b22e-2bd2-4e3e-b64f-c67d4fb4e3be', url = 'http://demo.ckan.org/')
#' }

ds_create <- function(url = 'http://demo.ckan.org', as='list', ...)
{
  res <- ckan_POST(url, 'datastore_create', body = body, ...)
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
