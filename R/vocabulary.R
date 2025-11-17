#' Manage CKAN vocabularies.
#'
#' CKAN restricts vocabulary creation, updates, and deletions to sysadmin
#' users. Each helper wraps the matching `/api/3/action/vocabulary_*` endpoint.
#'
#' @name vocabulary
#' @param id (character or `ckan_vocabulary`) Vocabulary id or name. Can also be
#'   an existing `ckan_vocabulary` object.
#' @param name (character) Unique vocabulary name.
#' @param tags (list) Optional list of tag objects, each containing at least a
#'   `name` field. See <https://docs.ckan.org/en/latest/api/> for the full
#'   structure.
#' @param include_datasets (logical) Return datasets owned by the vocabulary.
#'   Only applies to `vocabulary_show()`.
#' @template args
#' @template key
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#'
#' vocab_name <- sprintf("demo_vocab_%s", sample.int(1e6, 1))
#' vocab <- vocabulary_create(name = vocab_name)
#'
#' vocabulary_show(vocab$id)
#' vocabulary_update(vocab, name = paste0(vocab_name, "_updated"))
#' vocabulary_list()
#' vocabulary_delete(vocab)
#' }
NULL

#' @rdname vocabulary
#' @export
vocabulary_list <- function(url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_GET(url, 'vocabulary_list', list(), key = key, opts = list(...))
  switch(as, json = res, list = lapply(jsl(res), as.ckan_vocabulary),
    table = jsd(res))
}

#' @rdname vocabulary
#' @export
vocabulary_show <- function(id, include_datasets = FALSE,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_vocabulary(id, url = url, key = key)
  args <- cc(list(id = id$id, include_datasets = as_log(include_datasets)))
  res <- ckan_GET(url, 'vocabulary_show', args, key = key, opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_vocabulary"),
    table = jsd(res))
}

#' @rdname vocabulary
#' @export
vocabulary_create <- function(name, tags = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(name = name, tags = tags))
  res <- ckan_POST(url, 'vocabulary_create', body = args, key = key,
    opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_vocabulary"),
    table = jsd(res))
}

#' @rdname vocabulary
#' @export
vocabulary_update <- function(id, name = NULL, tags = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_vocabulary(id, url = url, key = key)
  args <- cc(list(id = id$id, name = name, tags = tags))
  res <- ckan_POST(url, 'vocabulary_update', body = args, key = key,
    opts = list(...))
  switch(as, json = res, list = as_ck(jsl(res), "ckan_vocabulary"),
    table = jsd(res))
}

#' @rdname vocabulary
#' @export
vocabulary_delete <- function(id, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  id <- as.ckan_vocabulary(id, url = url, key = key)
  res <- ckan_POST(url, 'vocabulary_delete', body = list(id = id$id), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Autocomplete tag names.
#'
#' @export
#' @param q (character) Partial tag name to search for. Required.
#' @param vocabulary_id (character) Restrict matches to a specific vocabulary.
#' @template args
#' @template key
#' @examples \dontrun{
#' tag_autocomplete(q = 'ckan')
#' }
tag_autocomplete <- function(q, vocabulary_id = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  args <- cc(list(q = q, vocabulary_id = vocabulary_id))
  res <- ckan_GET(url, 'tag_autocomplete', args, key = key, opts = list(...))
  values <- unlist(jsl(res), use.names = FALSE)
  switch(as, json = res, list = values,
    table = data.frame(name = values, stringsAsFactors = FALSE))
}
