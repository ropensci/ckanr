#' Create a user.
#'
#' @export
#'
#' @param name (character) the name of the new user, a string between 2 and 100
#' characters in length, containing only lowercase alphanumeric
#' characters, - and _ (required)
#' @param email (character) the email address for the new user (required)
#' @param password (character) the password of the new user, a string of at
#' least 4 characters (required)
#' @param id (character) the id of the new user (optional)
#' @param fullname (character) user full name
#' @param about (character) a description of the new user (optional)
#' @param openid (character) an openid (optional)
#' @template key
#' @template args
#' @references
#' http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.create.user_create
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://data-demo.dpaw.wa.gov.au",
#'   key = "824e7c50-9577-4bfa-bf32-246ebed1a8a2")
#'
#' # create a user
#' user_create(name = 'stacy', email = "stacy@aaaaa.com",
#' password = "helloworld")
#' }
user_create <- function(name, email, password, id = NULL, fullname = NULL,
  about = NULL, openid = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(name = name, email = email, password = password, id = id,
                  fullname = fullname, about = about, openid = openid))
  res <- ckan_POST(url, 'user_create', args, key = key, opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_user"), table = jsd(res))
}
