#' Search for packages.
#'
#' @export
#'
#' @param q Query terms, defaults to '*:*', or everything.
#' @param fq Filter query, this does not affect the search, only what gets returned
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc),
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of
#' x_f and y_f in a descending order).
#' @param rows Number of records to return. Defaults to 10.
#' @param start Record to start at, default to beginning.
#' @param facet (logical) Whether to return facet results or not. Default: FALSE
#' @param facet.limit (numeric) This param indicates the maximum number of
#' constraint counts that should be returned for the facet fields.
#' A negative value means unlimited. Default: 100.
#' Can be specified on a per field basis.
#' @param facet.field (charcter) This param allows you to specify a field which
#' should be treated as a facet. It will iterate over each Term in the field and
#' generate a facet count using that Term as the constraint. This parameter can
#' be specified multiple times to indicate multiple facet fields. None of the
#' other params in this section will have any effect without specifying at least
#' one field name using this param.
#' @template args
#' @examples \dontrun{
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
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
                           start = NULL, facet = FALSE, facet.limit = NULL,
                           facet.field = NULL,
                           url = get_default_url(), as = 'list', ...) {

  body <- cc(list(q = q, fq = fq, sort = sort, rows = rows, start = start,
                  facet = as_log(facet), facet.limit = facet.limit,
                  facet.field = facet.field))
  res <- ckan_POST(url, 'package_search', key = NULL,
                   body = tojun(body, TRUE), encode = "json", ctj(), ...)
  switch(as, json = res,
         list = {
           tmp <- jsl(res)
           tmp$results <- lapply(tmp$results, as.ckan_package)
           tmp
         },
         table = jsd(res))
}
