#' Datastore - create a dataset
#'
#' @export
#'
#' @param package_id (character) Package ID to add dataset to (required)
#' @param name (character) Name of the new dataset (required)
#' @param path (character) Path of the file to add (required)
#' @param key API key (required)
#' @template args
#' @examples \donttest{
#' ds_create_dataset(package_id='testingagain', name="mydata",
#'                    path="~/github/sac/theplantlist/Actinidiaceae.csv",
#'                    key=getOption('ckan_demo_key'))
#' }

ds_create_dataset <- function(package_id, name, path, key, url = 'http://demo.ckan.org', as='list', ...)
{
  path <- path.expand(path)
  ext <- strsplit(basename(path), "\\.")[[1]]
  ext <- ext[length(ext)]
  body <- list(package_id=package_id, name=name, format=ext, url='upload', upload=upload_file(path))
  res <- POST(file.path(url, 'api/action/resource_create'), add_headers(Authorization=key), body=body, ...)
  stop_for_status(res)
  res <- content(res, "text")
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
