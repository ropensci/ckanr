#' Create a group
#'
#' @export
#'
#' @param name (character) the name of the new dataset. It must be between 2 and
#' 100 characters long and contain only lowercase alphanumeric characters,
#' - and _, for example 'warandpeace'
#' @param id (character) The id of the group (optional)
#' @param title (character) The title of the dataset (optional, default:
#' same as name)
#' @param description (character) The description of the group (optional)
#' @param image_url (character) The URL of an image for the
#' group's page (optional)
#' @param type (character) The type of the dataset (optional). IDatasetForm
#' plugins link to different dataset types. They provide custom behaviour
#' for handling these types
#' @param state (character) The current state of the dataset, for example 'active' or
#' 'deleted' (optional, default: 'active'). Only active datasets appear in search results and other lists
#' of datasets. If you lack permission to change the state of the dataset, the function ignores this parameter.
#' @param approval_status (character) Approval status (optional)
#' @param extras (list of dataset extra dictionaries) The dataset's extras
#' (optional). Extras are arbitrary (key: value) metadata items for datasets.
#' Each extra dictionary must have keys 'key' (a string) and
#' 'value' (a string)
#' @param packages (data.frame) The datasets (packages) that belong
#' to the group. It is a data.frame. Each row has column 'name' (string, the id
#' or name of the dataset) and optionally 'title' (string, the title of
#' the dataset)
#' @param groups (data.frame) The groups to which the dataset
#' belongs (optional). Each data.frame row must have one or more of the
#' following columns that identify an existing group: 'id' (the id of the group,
#' string) or 'name' (the name of the group, string). To see which groups
#' exist, call [group_list()]
#' @param users (list of dictionaries) The users that belong to the group.
#' It is a list of dictionaries. Each dictionary has key 'name' (string, the id or name of the
#' user) and optionally 'capacity' (string, the capacity in which the user is
#' a member of the group)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a group
#' (res <- group_create("fruitloops2", description = "A group about fruitloops"))
#' res$users
#' res$num_followers
#' }
group_create <- function(
  name = NULL, id = NULL, title = NULL,
  description = NULL, image_url = NULL, type = NULL, state = "active",
  approval_status = NULL, extras = NULL, packages = NULL, groups = NULL,
  users = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  body <- cc(list(
    name = name, id = id, title = title,
    description = description, image_url = image_url, type = type,
    state = state, approval_status = approval_status, extras = extras,
    packages = packages, groups = groups, users = users
  ))
  res <- ckan_POST(url, "group_create",
    body = tojun(body, TRUE), key = key,
    encode = "json", ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_group"),
    table = jsd(res)
  )
}
