#' Update a package
#'
#' @description This function updates all package metadata fields.
#' Each update sets the metadata key "last_updated".
#'
#' On CKAN < 2.12 the function overwrites any omitted metadata fields:
#' any metadata fields missing from `x` are deleted in the package. On
#' CKAN 2.12 and later the internal `allow_partial_update` context was
#' removed (<https://github.com/ckan/ckan/pull/8155>): calling
#' `package_update()` without `resources` now keeps existing resources
#' instead of wiping them. To partially update nested fields on any
#' version, prefer [package_patch()] or [package_revise()].
#'
#' CKAN 2.12+ also reports whether the update made a real change via a
#' `changed_entities` envelope value
#' (<https://github.com/ckan/ckan/pull/8407>); the value is part of the
#' returned payload when the server provides it.
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Package identifier
#' @param http_method (character) Which HTTP method (verb) to use. Use one of "GET" or
#' "POST". Default: "GET"
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # Step 1: get the dataset details as R list
#' ds_id <- "my-dataset-id-md5-hash"
#' ds <- ckanr::package_show(ds_id, as = "table")
#'
#' # Step 2: update selected fields
#' ds$title <- "An updated title"
#' ds$description <- "Only title and description have been updated."
#' # ds contains all other package data, including tags and resources
#'
#' # Step 3a: Update the dataset on CKAN with locally modified metadata `ds`
#' result <- ckanr::package_update(ds, ds_id)
#' # Replace existing package metadata
#'
#' # Step 3b: Possible or intended data loss on CKAN < 2.12
#' # Any metadata fields missing from `ds` will be deleted in the package
#' # (on CKAN 2.12+ omitted `resources` are kept; use package_patch() or
#' # package_revise() for partial updates on any version)
#' del(ds$description)
#' result_with_deleted_description <- ckanr::package_update(ds, ds_id)
#' }
package_update <- function(x, id, http_method = "GET", url = get_default_url(),
                           key = get_default_key(), as = "list", ...) {
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  id <- as.ckan_package(id, url = url, key = key, http_method = http_method)
  x$id <- id$id
  res <- ckan_POST(url,
    method = "package_update",
    body = tojun(x, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_package"),
    table = jsd(res)
  )
}
