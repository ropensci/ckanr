#' Purge a group
#'
#' IMPORTANT: You must be a sysadmin to purge a group. Purging a group
#' cannot be undone: it completely removes the group from the CKAN database,
#' whereas deleting a group only marks it as deleted. Datasets in the group
#' remain, just no longer in the purged group. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.delete.group_purge>
#' for the official API contract.
#'
#' @export
#'
#' @param id (character or `ckan_group`) The name or id of the group to
#' purge, or a `ckan_group` object.
#' @template key
#' @template args
#' @return The function returns an empty list on success
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.delete.group_purge
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a group
#' (res <- group_create("foobar-group",
#'   title = "Foo bars",
#'   description = "love foo bars"
#' ))
#'
#' # delete the group just created
#' res$id
#' group_delete(id = res$id)
#'
#' # purge the group just deleted
#' res$id
#' group_purge(id = res$id)
#' }
group_purge <- function(
  id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  id <- as.ckan_group(id, url = url)
  res <- ckan_POST(url, "group_purge", list(id = id$id), key = key, ...)
  switch(as,
    json = res,
    list = lapply(jsl(res), as.ckan_group),
    table = jsd(res)
  )
}
