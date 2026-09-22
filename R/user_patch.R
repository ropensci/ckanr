#' Patch a user account.
#'
#' This function partially updates a user account: it updates only the
#' provided parameters and leaves all other parameters unchanged (unlike
#' [user_update()], which may delete parameters not explicitly provided).
#' Normal users can only patch their own user accounts; sysadmins can patch
#' any user account. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.patch.user_patch>
#' for the official API contract.
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character or `ckan_user`) The id or name of the user to patch,
#' or a `ckan_user` object.
#' @template args
#' @template key
#' @return The patched user account as a `ckan_user` object.
#' With `as = "table"`, a data.frame; with `as = "json"`, the raw JSON
#' response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.patch.user_patch
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # Create a user, then patch it
#' usr <- user_create(
#'   name = "stacy-patch", email = "stacy-patch@example.com",
#'   password = "helloworld"
#' )
#' user_patch(list(about = "patched via ckanr"), id = usr)
#'
#' # Clean up
#' user_delete(usr$id)
#' }
user_patch <- function(
  x, id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  id <- as.ckan_user(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url,
    method = "user_patch",
    body = tojun(x, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_user"),
    table = jsd(res)
  )
}
