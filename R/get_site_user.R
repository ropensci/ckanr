#' Show the CKAN site user.
#'
#' Return the CKAN site user. The site user is a special internal user that
#' the web interface and background jobs use for internal operations. You
#' must be a sysadmin to call this endpoint. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.get_site_user>
#' for the official API contract.
#'
#' @export
#' @param defer_commit (logical) By default (`FALSE`), `get_site_user`
#' commits and cleans up the current transaction. If `TRUE`, the caller is
#' responsible for committing the transaction after the call. Leaving open
#' connections can cause CLI commands to hang (optional).
#' @template args
#' @template key
#' @return A `ckan_user` object. With `as = "table"`, a data.frame; with
#' `as = "json"`, the raw JSON response.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.get.get_site_user
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' get_site_user()
#' }
get_site_user <- function(
  defer_commit = FALSE, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  args <- cc(list(defer_commit = as_log(defer_commit)))
  res <- ckan_GET(url, "get_site_user", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_user"),
    table = jsd(res)
  )
}
