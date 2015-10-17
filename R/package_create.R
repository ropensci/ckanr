#' Create a package
#'
#' @export
#'
#' @param name (character) the name of the new dataset, must be between 2 and 100 characters
#' long and contain only lowercase alphanumeric characters, - and _, e.g. 'warandpeace'
#' @param title (character) the title of the dataset (optional, default: same as name)
#' @param author (character) the name of the dataset's author (optional)
#' @param author_email (character) the email address of the dataset's author (optional)
#' @param maintainer (character) the name of the dataset's maintainer (optional)
#' @param maintainer_email (character) the email address of the dataset's maintainer (optional)
#' @param license_id (license id string) - the id of the dataset's license, see license_list()
#' for available values (optional)
#' @param notes (character) a description of the dataset (optional)
#' @param package_url (character) a URL for the dataset's source (optional)
#' @param version (string, no longer than 100 characters) - (optional)
#' @param state (character) the current state of the dataset, e.g. 'active' or 'deleted',
#' only active datasets show up in search results and other lists of datasets, this parameter
#' will be ignored if you are not authorized to change the state of the dataset (optional,
#' default: 'active')
#' @param type (character) the type of the dataset (optional), IDatasetForm plugins associate
#' themselves with different dataset types and provide custom dataset handling behaviour
#' for these types
#' @param resources (list of resource dictionaries) - the dataset's resources, see
#' resource_create() for the format of resource dictionaries (optional)
#' @param tags (list of tag dictionaries) - the dataset's tags, see tag_create() for the
#' format of tag dictionaries (optional)
#' @param extras (list of dataset extra dictionaries) - the dataset's extras (optional),
#' extras are arbitrary (key: value) metadata items that can be added to datasets, each
#' extra dictionary should have keys 'key' (a string), 'value' (a string)
#' @param relationships_as_object (list of relationship dictionaries) - see
#' package_relationship_create() for the format of relationship dictionaries (optional)
#' @param relationships_as_subject (list of relationship dictionaries) - see
#' package_relationship_create() for the format of relationship dictionaries (optional)
#' @param groups (list of dictionaries) - the groups to which the dataset belongs (optional),
#' each group dictionary should have one or more of the following keys which identify an
#' existing group: 'id' (the id of the group, string), or 'name' (the name of the group,
#' string), to see which groups exist call group_list()
#' @param owner_org (character) the id of the dataset's owning organization, see
#' organization_list() or organization_list_for_user() for available values (optional)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create a package
#' ## Example 1
#' (res <- package_create("foobar4", author="Jane Doe"))
#' res$author
#'
#' ## Example 2 - create package, add a resource
#' (res <- package_create("helloworld", author="Jane DOe"))
#'
#' }
package_create <- function(name = NULL, title = NULL, author = NULL, author_email = NULL,
  maintainer = NULL, maintainer_email = NULL, license_id = NULL, notes = NULL, package_url = NULL,
  version = NULL, state = "active", type = NULL, resources = NULL, tags = NULL, extras = NULL,
  relationships_as_object = NULL, relationships_as_subject = NULL, groups = NULL,
  owner_org = NULL, key = get_default_key(), url = get_default_url(), as = 'list', ...) {

  body <- cc(list(name = name, title = title, author = author, author_email = author_email,
    maintainer = maintainer, maintainer_email = maintainer_email, license_id = license_id,
    notes = notes, url = package_url, version = version, state = state, type = type,
    resources = resources, tags = tags, extras = extras,
    relationships_as_object = relationships_as_object,
    relationships_as_subject = relationships_as_subject, groups = groups,
    owner_org = owner_org))
  res <- ckan_POST(url, 'package_create',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_package"), table = jsd(res))
}
