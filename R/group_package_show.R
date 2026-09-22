#' Show the datasets of a group.
#'
#' Return the datasets (packages) that belong to a group. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.group_package_show>
#' for the official API contract.
#'
#' @export
#' @param id (character or `ckan_group`) The id or name of the group, or a
#' `ckan_group` object.
#' @param limit (numeric) The maximum number of datasets to return (optional).
#' @template args
#' @template key
#' @return A list of `ckan_package` objects. With `as = "table"`, a data.frame;
#' with `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.group_package_show
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' res <- group_list()
#' group_package_show(res[[1]]$name)
#' group_package_show(res[[1]], limit = 5, as = "table")
#' }
group_package_show <- function(
  id, limit = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  id <- as.ckan_group(id, url = url)
  args <- cc(list(id = id$id, limit = limit))
  res <- ckan_GET(url, "group_package_show", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = lapply(jsl(res), as.ckan_package),
    table = jsd(res)
  )
}
