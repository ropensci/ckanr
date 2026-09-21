#' Create an organization
#'
#' @export
#'
#' @param name (character) the name of the organization. It is a string between 2 and
#' 100 characters long. It contains only lowercase alphanumeric characters,
#' - and _
#' @param id the id of the organization (optional)
#' @param title (character) the title of the organization (optional)
#' @param description (character) the description of the organization (optional)
#' @param image_url (character) the URL of an image for the
#' organization's page (optional)
#' @param state (character) the current state of the organization, for example
#' 'active' or 'deleted' (optional). Only active organizations appear in search results
#' and other lists of organizations. If you lack permission to change the state of the organization,
#' the function ignores this parameter.
#' Default: 'active'
#' @param approval_status (character) Approval status
#' @param extras The organization's extras (optional). Extras are arbitrary
#' (key: value) metadata items for organizations. Each extra
#' dictionary must have keys 'key' (a string) and 'value' (a string).
#' See `package_relationship_create` for the format of relationship dictionaries
#' (optional)
#' @param packages (list of dictionaries) the datasets (packages) that belong
#' to the organization. It is a list of dictionaries. Each dictionary has keys 'name' (string,
#' the id or name of the dataset) and optionally 'title' (string, the title
#' of the dataset)
#' @param users (character) the users that belong to the organization. It is a list
#' of dictionaries. Each dictionary has key 'name' (string, the id or name of the user)
#' and optionally 'capacity' (string, the capacity in which the user is a
#' member of the organization)
#' @template args
#' @template key
#'
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # create an organization
#' (res <- organization_create("foobar",
#'   title = "Foo bars",
#'   description = "love foo bars"
#' ))
#' res$name
#' }
organization_create <- function(
  name = NULL, id = NULL, title = NULL,
  description = NULL, image_url = NULL, state = "active", approval_status = NULL,
  extras = NULL, packages = NULL, users = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  body <- cc(list(
    name = name, id = id, title = title, description = description,
    image_url = image_url, state = state, approval_status = approval_status,
    extras = extras, packages = packages, users = users
  ))
  res <- ckan_POST(url, "organization_create",
    body = tojun(body, TRUE),
    key = key, encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_organization"),
    table = jsd(res)
  )
}
