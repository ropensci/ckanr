#' Create a package
#'
#' @export
#'
#' @param name (character) the name of the new dataset. It must be between 2 and
#' 100 characters long and contain only lowercase alphanumeric characters, -
#' and _, for example 'warandpeace'
#' @param title (character) the title of the dataset (optional, default: same
#' as name)
#' @param private (logical) whether the dataset is private (optional,
#' default: `FALSE`). If `TRUE`, you must give a value for `owner_org`.
#' @param author (character) the name of the dataset's author (optional)
#' @param author_email (character) the email address of the dataset's author
#' (optional)
#' @param maintainer (character) the name of the dataset's maintainer
#' (optional)
#' @param maintainer_email (character) the email address of the dataset's
#' maintainer (optional)
#' @param license_id (license id string) The id of the dataset's license.
#' See license_list() for available values (optional)
#' @param notes (character) a description of the dataset (optional)
#' @param package_url (character) a URL for the dataset's source (optional)
#' @param version (string, no longer than 100 characters) (optional)
#' @param state (character) the current state of the dataset, for example 'active'
#' or 'deleted' (optional, default: 'active'). Only active datasets appear in search results and other
#' lists of datasets. If you lack permission to change the state of the dataset, the function ignores
#' this parameter.
#' @param type (character) the type of the dataset (optional). IDatasetForm
#' plugins link to different dataset types. They provide custom behaviour
#' for handling these types
#' @param resources (list of resource dictionaries) The dataset's resources.
#' See [resource_create()] for the format of resource dictionaries (optional)
#' @param tags (list of tag dictionaries) The dataset's tags. See
#' [tag_create()] for the format of tag dictionaries (optional)
#' @param extras (list of dataset extra dictionaries) The dataset's extras
#' (optional). Extras are arbitrary (key: value) metadata items for datasets.
#' Each extra dictionary must have keys 'key' (a string) and
#' 'value' (a string)
#' @param relationships_as_object (list of relationship dictionaries) See
#' `package_relationship_create` for the format of relationship dictionaries
#' (optional)
#' @param relationships_as_subject (list of relationship dictionaries) See
#' `package_relationship_create` for the format of relationship dictionaries
#' (optional)
#' @param groups (data.frame) the groups to which the dataset
#' belongs. Each row must have one or more of the
#' following columns that identify an existing group: 'id' (the id of the group,
#' string) or 'name' (the name of the group, string). To see which groups
#' exist, call [group_list()]. See example (optional)
#' @param owner_org (character) the id of the dataset's owning organization.
#' See [organization_list()] or `organization_list_for_user` for available
#' values (optional)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' ## Example 1
#' (res <- package_create("foobar4", author = "Jane Doe"))
#' res$author
#'
#' ## Example 2 - create package, add a resource
#' (res <- package_create("helloworld", author = "Jane DOe"))
#'
#' # include a group
#' # package_create("brownbear", groups = data.frame(id = "some-id"))
#' }
package_create <- function(
  name = NULL, title = NULL, private = FALSE,
  author = NULL, author_email = NULL, maintainer = NULL,
  maintainer_email = NULL, license_id = NULL, notes = NULL, package_url = NULL,
  version = NULL, state = "active", type = NULL, resources = NULL, tags = NULL,
  extras = NULL, relationships_as_object = NULL,
  relationships_as_subject = NULL, groups = NULL, owner_org = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  body <- cc(list(
    name = name, title = title, private = private,
    author = author, author_email = author_email, maintainer = maintainer,
    maintainer_email = maintainer_email, license_id = license_id,
    notes = notes, url = package_url, version = version, state = state,
    type = type, resources = resources, tags = tags,
    relationships_as_object = relationships_as_object,
    relationships_as_subject = relationships_as_subject, groups = groups,
    owner_org = owner_org
  ))
  body <- c(body, extras)
  res <- ckan_POST(url, "package_create",
    body = tojun(body, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_package"),
    table = jsd(res)
  )
}
