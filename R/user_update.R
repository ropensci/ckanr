#' Update a user account.
#'
#' Normal users can only update their own user accounts. Sysadmins can update
#' any user account and modify existing usernames. Update methods may delete
#' parameters not explicitly provided: if you want to edit only specific
#' attributes, use [user_patch()] instead. For the full list of accepted
#' fields, see [user_create()] and
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.user_update>.
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character or `ckan_user`) The name or id of the user to update,
#' or a `ckan_user` object.
#' @template args
#' @template key
#' @return The updated user account as a `ckan_user` object.
#' With `as = "table"`, a data.frame; with `as = "json"`, the raw JSON
#' response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.update.user_update
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' # Create a user, then update it (user_update replaces the whole account,
#' # so fetch the full object first and modify it)
#' usr <- user_create(
#'   name = "stacy-update", email = "stacy-update@example.com",
#'   password = "helloworld"
#' )
#' full <- unclass(user_show(usr$id))
#' full$fullname <- "Stacy Updated"
#' user_update(full, id = usr)
#'
#' # Clean up
#' user_delete(usr$id)
#' }
user_update <- function(
  x, id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  id <- as.ckan_user(id, url = url)
  if (!inherits(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url,
    method = "user_update",
    body = tojun(x, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_user"),
    table = jsd(res)
  )
}
