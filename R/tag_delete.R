#' Delete a tag.
#'
#' Delete a tag. You must be a sysadmin to delete tags. See
#' <https://docs.ckan.org/en/2.11/api/#ckan.logic.action.delete.tag_delete>
#' for the official API contract.
#'
#' @export
#' @param id (character or `ckan_tag`) The id or name of the tag to delete,
#' or a `ckan_tag` object.
#' @param vocabulary_id (character) The id or name of the vocabulary that
#' the tag belongs to. Omit it (default `NULL`) for free tags (optional).
#' @template key
#' @template args
#' @return (logical) `TRUE` when the function deletes the tag successfully.
#' @references
#' https://docs.ckan.org/en/2.11/api/#ckan.logic.action.delete.tag_delete
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org", key = getOption("ckan_demo_key"))
#'
#' # create a vocabulary and a tag in it
#' vocab <- vocabulary_create(name = "delete-me-vocab")
#' tag <- tag_create(name = "delete-me-tag", vocabulary_id = vocab$id)
#'
#' # delete the tag, then clean up the vocabulary
#' tag_delete(tag$id, vocabulary_id = vocab$id)
#' vocabulary_delete(vocab$id)
#' }
tag_delete <- function(
  id, vocabulary_id = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  tag_id <- NULL
  if (is.ckan_tag(id)) {
    tag_id <- id$id
  } else if (is.list(id) && !is.null(id$id)) {
    tag_id <- id$id
  } else if (is.character(id) && length(id) == 1) {
    tag_id <- id
  } else {
    stop("id must be a string or ckan_tag", call. = FALSE)
  }
  body <- cc(list(id = tag_id, vocabulary_id = vocabulary_id))
  res <- ckan_POST(url, "tag_delete",
    body = tojun(body, TRUE), key = key,
    encode = "json", headers = ctj(), opts = list(...)
  )
  parsed <- jsonlite::fromJSON(res)
  switch(as,
    json = res,
    list = isTRUE(parsed$success),
    table = parsed$success
  )
}
