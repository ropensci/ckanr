#' Bulk update dataset visibility.
#'
#' Make a list of datasets private, public, or deleted in a single call.
#' You must be authorized to edit the datasets (for example, an editor or
#' admin of the owning organization). See the official API contracts:
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.bulk_update_private>,
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.bulk_update_public>,
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.bulk_update_delete>.
#'
#' @name bulk_update
#' @param datasets (character or list) The datasets to update: a character
#' vector of dataset ids or names, a list of `ckan_package` objects, or a
#' list with an `id` entry per dataset.
#' @param org_id (character or `ckan_organization`) The id or name of the
#' owning organization, or a `ckan_organization` object.
#' @template key
#' @template args_noas
#' @return (logical) `TRUE` when CKAN applies the bulk update successfully.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.bulk_update_private
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' org <- organization_create("bulk-org")
#' ds1 <- package_create("bulk-dataset-1", owner_org = org$id)
#' ds2 <- package_create("bulk-dataset-2", owner_org = org$id)
#'
#' bulk_update_private(c(ds1$id, ds2$id), org_id = org$id)
#' bulk_update_public(c(ds1$id, ds2$id), org_id = org$id)
#' bulk_update_delete(c(ds1$id, ds2$id), org_id = org$id)
#' }
NULL

#' @rdname bulk_update
#' @export
bulk_update_private <- function(
  datasets, org_id, url = get_default_url(),
  key = get_default_key(), ...
) {
  bulk_update_request("bulk_update_private", datasets, org_id,
    url = url, key = key, opts = list(...)
  )
}

#' @rdname bulk_update
#' @export
bulk_update_public <- function(
  datasets, org_id, url = get_default_url(),
  key = get_default_key(), ...
) {
  bulk_update_request("bulk_update_public", datasets, org_id,
    url = url, key = key, opts = list(...)
  )
}

#' @rdname bulk_update
#' @export
bulk_update_delete <- function(
  datasets, org_id, url = get_default_url(),
  key = get_default_key(), ...
) {
  bulk_update_request("bulk_update_delete", datasets, org_id,
    url = url, key = key, opts = list(...)
  )
}

resolve_bulk_org_id <- function(org_id, url) {
  org <- as.ckan_organization(org_id, url = url)
  org$id
}

resolve_bulk_dataset_ids <- function(datasets) {
  ids <- NULL
  if (is.ckan_package(datasets)) {
    ids <- datasets$id
  } else if (is.character(datasets)) {
    ids <- unname(datasets)
  } else if (is.list(datasets)) {
    ids <- vapply(datasets, function(x) {
      if (is.ckan_package(x)) {
        x$id
      } else if (is.list(x) && !is.null(x$id)) {
        as.character(x$id)
      } else if (is.character(x) && length(x) == 1) {
        x
      } else {
        stop("each entry of 'datasets' must be a dataset id or ckan_package",
          call. = FALSE
        )
      }
    }, character(1))
  } else {
    stop("datasets must be a character vector or a (list of) ckan_package",
      call. = FALSE
    )
  }
  ids <- ids[!is.na(ids) & nzchar(ids)]
  if (!length(ids)) {
    stop("datasets must contain at least one dataset id", call. = FALSE)
  }
  unname(ids)
}

bulk_update_request <- function(endpoint, datasets, org_id, url, key, opts) {
  dataset_ids <- resolve_bulk_dataset_ids(datasets)
  org <- resolve_bulk_org_id(org_id, url)
  body <- list(datasets = as.list(dataset_ids), org_id = org)
  res <- ckan_POST(url, endpoint,
    body = tojun(body, TRUE), key = key,
    encode = "json", headers = ctj(), opts = opts
  )
  isTRUE(jsonlite::fromJSON(res)$success)
}
