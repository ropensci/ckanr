#' Search for packages.
#'
#' @export
#'
#' @param q Query terms, defaults to '*:*', or everything.
#' @param fq Filter query, this does not affect the search, only what gets 
#' returned
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) 
#' or descending (e.g., score asc), sort by two fields (e.g., score desc, 
#' price asc), or sort by a function (e.g., sum(x_f, y_f) desc, which sorts 
#' by the sum of x_f and y_f in a descending order).
#' @param rows Number of records to return. Defaults to 10.
#' @param start Record to start at, default to beginning.
#' @param facet (logical) Whether to return facet results or not. 
#' Default: FALSE
#' @param facet.limit (numeric) This param indicates the maximum number of
#' constraint counts that should be returned for the facet fields.
#' A negative value means unlimited. Default: 100.
#' Can be specified on a per field basis.
#' @param facet.field (charcter) This param allows you to specify a field which
#' should be treated as a facet. It will iterate over each Term in the field 
#' and generate a facet count using that Term as the constraint. This parameter 
#' can be specified multiple times to indicate multiple facet fields. None of 
#' the other params in this section will have any effect without specifying at 
#' least one field name using this param.
#' @param facet.mincount (integer) the minimum counts for facet fields should 
#' be included in the results
#' @param include_drafts (logical) if \code{TRUE} draft datasets will be 
#' included. A user will only be returned their own draft datasets, and a 
#' sysadmin will be returned all draft datasets. default: \code{FALSE}.
#' first CKAN version: 2.4.9; dropped from request if CKAN version is older
#' @param include_private (logical) if \code{TRUE} private datasets will be 
#' included. Only private datasets from the user’s organizations will be 
#' returned and sysadmins will be returned all private datasets.
#' default: \code{FALSE}
#' first CKAN version: 2.6; dropped from request if CKAN version is older
#' @param use_default_schema (logical) use default package schema instead of a
#' custom schema defined with an IDatasetForm plugin. default: \code{FALSE}
#' first CKAN version: 2.3.5; dropped from request if CKAN version is older
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key=getOption("ckan_demo_key"))
#'
#' package_search(q = '*:*')
#' package_search(q = '*:*', rows = 2, as = 'json')
#' package_search(q = '*:*', rows = 2, as = 'table')
#'
#' package_search(q = '*:*', sort = 'score asc')
#' package_search(q = '*:*', fq = 'num_tags:[3 TO *]')$count
#' package_search(q = '*:*', fq = 'num_tags:[2 TO *]')$count
#' package_search(q = '*:*', fq = 'num_tags:[1 TO *]')$count
#' }
package_search <- function(q = '*:*', fq = NULL, sort = NULL, rows = NULL,
  start = NULL, facet = FALSE, facet.limit = NULL, facet.field = NULL,
  facet.mincount = NULL, include_drafts = FALSE, include_private = FALSE, 
  use_default_schema = FALSE, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  ver <- ckan_version(url)$version_num
  args <- cc(list(
    q = q, fq = fq, sort = sort, rows = rows, start = start,
    facet = as_log(facet), facet.limit = facet.limit,
    facet.field = facet.field, facet.mincount = facet.mincount,
    include_drafts = as_log(include_drafts), 
    include_private = as_log(include_private), 
    use_default_schema = as_log(use_default_schema)
  ))
  if (ver <= 23) {
    args$use_default_schema <- args$include_drafts <- args$include_private <- NULL
  }
  if (ver < 24) args$include_drafts <- args$include_private <- NULL
  if (ver < 26) args$include_private <- NULL
  res <- ckan_GET(url, 'package_search', args, key = key, ...)
  switch(as, json = res,
         list = {
           tmp <- jsl(res)
           tmp$results <- lapply(tmp$results, as.ckan_package)
           tmp
         },
         table = jsd(res))
}
