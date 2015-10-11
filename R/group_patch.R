#' Update a group's metadata
#'
#' @export
#' @param x (list) A list with key-value pairs
#' @param id (character) Resource ID to update (required)
#' @template args
#' @template key
#' @examples \dontrun{
#' # Setup
#' ckanr_setup(url = "http://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # Create a package
#' (res <- group_create("hello-my-world2"))
#'
#' # Get a resource
#' grp <- group_show(res$id)
#' grp$title
#' grp$author_email
#'
#' # Make some changes
#' x <- list(title = "!hello world!", maintainer_email = "hello@@world.com")
#' group_patch(x, id = grp)
#' }
group_patch <- function(x, id, key = get_default_key(),
                           url = get_default_url(), as = 'list', ...) {
  id <- as.ckan_group(id, url = url)
  if (!is(x, "list")) {
    stop("x must be of class list", call. = FALSE)
  }
  x$id <- id$id
  res <- ckan_POST(url, method = 'group_patch',
                   body = tojun(x, TRUE), key = key,
                   encode = "json", ctj(), ...)
  switch(as, json = res, list = as_ck(jsl(res), "ckan_group"), table = jsd(res))
}
