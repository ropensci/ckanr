#' Create a user.
#'
#' @export
#'
#' @param name (character) Name of the new user. The name is a string between
#' 2 and 100 characters in length. The name contains only lowercase alphanumeric
#' characters, - and _. Required.
#' @param email (character) Email address for the new user. Required.
#' @param password (character) Password of the new user. The password is a string
#' of at least 4 characters. Required.
#' @param id (character) ID of the new user. Optional. Plugins may set user
#' IDs at creation (CKAN 2.12+, <https://github.com/ckan/ckan/pull/8609>).
#' @param fullname (character) Full name of the user. Optional.
#' @param about (character) Description of the new user. Optional.
#' @param openid (character) OpenID of the new user. Optional.
#' @param image_url (character) URL to an image displayed on the user's page.
#' Optional.
#' @param plugin_extras (list) Private extra user data for plugins. Only
#' sysadmins may set this. Plugins should namespace extras with the plugin
#' name. Optional.
#' @param with_apitoken (logical) Create an API token for the user.
#' Optional.
#' @template key
#' @template args
#' @references
#' http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.create.user_create
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(
#'   url = "https://data-demo.dpaw.wa.gov.au",
#'   key = "824e7c50-9577-4bfa-bf32-246ebed1a8a2"
#' )
#'
#' # create a user
#' user_create(
#'   name = "stacy", email = "stacy@aaaaa.com",
#'   password = "helloworld"
#' )
#' }
user_create <- function(
  name, email, password, id = NULL, fullname = NULL,
  about = NULL, openid = NULL, image_url = NULL, plugin_extras = NULL,
  with_apitoken = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(
    name = name, email = email, password = password, id = id,
    fullname = fullname, about = about, openid = openid,
    image_url = image_url, plugin_extras = plugin_extras,
    with_apitoken = with_apitoken
  ))
  res <- ckan_POST(url, "user_create", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_user"),
    table = jsd(res)
  )
}
