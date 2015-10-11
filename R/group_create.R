#' Create a group
#'
#' @export
#'
#' @param name (character) the name of the new dataset, must be between 2 and 100 characters
#' long and contain only lowercase alphanumeric characters, - and _, e.g. 'warandpeace'
#' @param id (character) The id of the group (optional)
#' @param title (character) The title of the dataset (optional, default: same as name)
#' @param description (character) The description of the group (optional)
#' @param image_url (character) The URL to an image to be displayed on the
#' group's page (optional)
#' @param type (character) The type of the dataset (optional), IDatasetForm plugins associate
#' themselves with different dataset types and provide custom dataset handling behaviour
#' for these types
#' @param state (character) The current state of the dataset, e.g. 'active' or 'deleted',
#' only active datasets show up in search results and other lists of datasets, this parameter
#' will be ignored if you are not authorized to change the state of the dataset (optional,
#' default: 'active')
#' @param approval_status (character) Approval status (optional)
#' @param extras (list of dataset extra dictionaries) The dataset's extras (optional),
#' extras are arbitrary (key: value) metadata items that can be added to datasets, each
#' extra dictionary should have keys 'key' (a string), 'value' (a string)
#' @param packages (list of dictionaries) The datasets (packages) that belong to the group,
#' a list of dictionaries each with keys 'name' (string, the id or name of the dataset)
#' and optionally 'title' (string, the title of the dataset)
#' @param groups (list of dictionaries) The groups to which the dataset belongs (optional),
#' each group dictionary should have one or more of the following keys which identify an
#' existing group: 'id' (the id of the group, string), or 'name' (the name of the group,
#' string), to see which groups exist call group_list()
#' @param users (list of dictionaries) The users that belong to the group, a list of
#' dictionaries each with key 'name' (string, the id or name of the user) and optionally
#' 'capacity' (string, the capacity in which the user is a member of the group)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a group
#' (res <- group_create("fruitloops2", description="A group about fruitloops"))
#' res$users
#' res$num_followers
#' }
group_create <- function(name = NULL, id = NULL, title = NULL, description = NULL,
  image_url = NULL, type = NULL, state = "active", approval_status = NULL, extras = NULL,
  packages = NULL, groups = NULL, users = NULL,
  key = get_default_key(), url = get_default_url(), as = 'list', ...) {

  body <- cc(list(name = name, id = id, title = title, description = description,
                  image_url = image_url, type = type, state = state,
                  approval_status = approval_status, extras = extras,
                  packages = packages, groups = groups, users = users))
  res <- ckan_POST(url, 'group_create',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_group"), table = jsd(res))
}
