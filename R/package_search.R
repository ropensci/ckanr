#' Search for packages.
#'
#' @export
#'
#' @param q Query terms, defaults to '*:*', or everything.
#' @param fq Filter query. It does not affect the search. It only controls
#' what the function returns.
#' @param sort Field to sort on. You can specify ascending order, for example score desc.
#' You can specify descending order, for example score asc. You can sort by two fields,
#' for example score desc, price asc. You can sort by a function, for example sum(x_f, y_f) desc.
#' The function then sorts by the sum of x_f and y_f in descending order.
#' @param rows Number of records to return. Defaults to 10.
#' @param start Record to start with. It defaults to the beginning.
#' @param facet (logical) Whether to return facet results or not.
#' Default: `FALSE`
#' @param facet.limit (numeric) The maximum number of
#' constraint counts for the facet fields. A negative value means unlimited. Default: 100.
#' You can set it for each field.
#' @param facet.field (character) This parameter sets a field to treat
#' as a facet. It iterates over each Term in the field.
#' It generates a facet count with that Term as the constraint. You
#' can give this parameter multiple times for multiple facet fields. If you omit
#' all field names for this parameter, the other parameters in this section have no effect.
#' @param facet.mincount (integer) the minimum counts for facet fields.
#' The results include only fields that meet this count.
#' @param include_drafts (logical) If `TRUE`, the function includes
#' draft datasets. A user gets only their own draft datasets. A
#' sysadmin gets all draft datasets. Default: `FALSE`.
#' First CKAN version: 2.6.1. If the CKAN version is older, or if the version is not
#' available through [ckan_version()], the function drops it from the request.
#' @param include_private (logical) If `TRUE`, the function includes
#' private datasets. It returns only private datasets from the user organizations.
#' Sysadmins get all private datasets.
#' Default: `FALSE`.
#' First CKAN version: 2.6.1. If the CKAN version is older, or if the version is not
#' available through [ckan_version()], the function drops it from the request.
#' @param use_default_schema (logical) Use default package schema instead of a
#' custom schema from an IDatasetForm plugin. Default: `FALSE`.
#' First CKAN version: 2.3.5. If the CKAN version is older, or if the version is not
#' available through [ckan_version()], the function drops it from the request.
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' package_search(q = "*:*")
#' package_search(q = "*:*", rows = 2, as = "json")
#' package_search(q = "*:*", rows = 2, as = "table")
#'
#' package_search(q = "*:*", sort = "score asc")
#' package_search(q = "*:*", fq = "num_tags:[3 TO *]")$count
#' package_search(q = "*:*", fq = "num_tags:[2 TO *]")$count
#' package_search(q = "*:*", fq = "num_tags:[1 TO *]")$count
#' }
package_search <- function(
  q = "*:*", fq = NULL, sort = NULL, rows = NULL,
  start = NULL, facet = FALSE, facet.limit = NULL, facet.field = NULL,
  facet.mincount = NULL, include_drafts = FALSE, include_private = FALSE,
  use_default_schema = FALSE, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  ver <- try(ckan_version(url)$version_num, silent = TRUE)
  if (inherits(ver, "try-error")) {
    ver <- NA
  }
  args <- cc(list(
    q = q, fq = fq, sort = sort, rows = rows, start = start,
    facet = as_log(facet), facet.limit = facet.limit,
    facet.field = facet.field, facet.mincount = facet.mincount,
    include_drafts = as_log(include_drafts),
    include_private = as_log(include_private),
    use_default_schema = as_log(use_default_schema)
  ))
  if (is.na(ver)) {
    args$include_drafts <- args$use_default_schema <- args$include_private <- NULL
  } else if (ver < 23.5) { # CKAN < 2.3.5: no use_default_schema/include_private/include_drafts
    args$include_drafts <- args$use_default_schema <- args$include_private <- NULL
  } else if (ver < 26.1) { # CKAN < 2.6.1: no include_private/include_drafts
    args$use_default_schema <- args$include_private <- NULL
  }
  res <- ckan_GET(url, "package_search", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = {
      tmp <- jsl(res)
      tmp$results <- lapply(tmp$results, as.ckan_package)
      tmp
    },
    table = jsd(res)
  )
}
