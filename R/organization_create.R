#' Create an organization
#'
#' @export
#'
#' @param name (character) the name of the organization, a string between 2 and 100
#' characters long, containing only lowercase alphanumeric characters, - and _
#' @param id the id of the organization (optional)
#' @param title (character) the title of the organization (optional)
#' @param description (character) the description of the organization (optional)
#' @param image_url (character) the URL to an image to be displayed on the
#' organization's page (optional)
#' @param state (character) the current state of the organization, e.g. 'active' or 'deleted',
#' only active organization show up in search results and other lists of organization,
#' this parameter will be ignored if you are not authorized to change the state of the
#' organization (optional). Default: 'active'
#' @param approval_status (character) Approval status
#' @param extras The organization's extras (optional), extras are arbitrary (key: value)
#' metadata items that can be added to organizations, each extra dictionary should have
#' keys 'key' (a string), 'value' (a string) package_relationship_create() for the format
#' of relationship dictionaries (optional)
#' @param packages (list of dictionaries) the datasets (packages) that belong to the
#' organization, a list of dictionaries each with keys 'name' (string, the id or name of the
#' dataset) and optionally 'title' (string, the title of the dataset)
#' @param users (character) the users that belong to the organization, a list of dictionaries
#' each with key 'name' (string, the id or name of the user) and optionally 'capacity'
#' (string, the capacity in which the user is a member of the organization)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create an organization
#' (res <- organization_create("foobar", title = "Foo bars", description = "love foo bars"))
#' res$name
#' }
organization_create <- function(name = NULL, id = NULL, title = NULL, description = NULL,
  image_url = NULL, state = "active", approval_status = NULL, extras = NULL, packages = NULL,
  users = NULL, key = get_default_key(), url = get_default_url(), as = 'list', ...) {

  body <- cc(list(name = name, id = id, title = title, description = description,
                  image_url = image_url, state = state, approval_status = approval_status,
                  extras = extras, packages = packages, users = users))
  res <- ckan_POST(url, 'organization_create',
                   body = tojun(body, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_organization"), table = jsd(res))
}
