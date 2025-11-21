#' Delete a user.
#'
#' @export
#'
#' @param id (character) the id of the new user (required)
#' @return (logical) TRUE when the user is successfully deleted
#' @template key
#' @template args
#' @references
#' http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.delete.user_delete
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "https://data-demo.dpaw.wa.gov.au",
#' key = "824e7c50-9577-4bfa-bf32-246ebed1a8a2")
#'
#' # create a user
#' res <- user_delete(name = 'stacy', email = "stacy@aaaaa.com",
#' password = "helloworld")
#'
#' # then, delete a user
#' user_delete(id = "stacy")
#' }
user_delete <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_POST(url, 'user_delete', list(id = id), encode = "json",
    key = key, opts = list(...))
  parsed <- jsonlite::fromJSON(res)
  switch(as,
    json = res,
    list = isTRUE(parsed$success),
    table = parsed$success
  )
}
