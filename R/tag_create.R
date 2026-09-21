#' Create a tag
#'
#' You must be a sysadmin to create vocabulary tags.
#'
#' @export
#'
#' @param name (character) Name for the new tag. The name is a string between
#' 2 and 100 characters long. The name contains only alphanumeric characters
#' and -, _ and .. For example, 'Jazz'.
#' @param vocabulary_id (character) ID of the vocabulary. You add the new tag
#' to this vocabulary. For example, the ID of vocabulary 'Genre'.
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(
#'   url = "https://demo.ckan.org/",
#'   key = Sys.getenv("CKAN_DEMO_KEY")
#' )
#' tag_create(name = "TestTag1", vocabulary_id = "Testing1")
#' }
tag_create <- function(
  name, vocabulary_id,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  body <- cc(list(name = name, vocabulary_id = vocabulary_id))
  res <- ckan_POST(url, "tag_create",
    body = tojun(body, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  switch(as,
    json = res,
    list = as_ck(jsl(res), "ckan_tag"),
    table = jsd(res)
  )
}
