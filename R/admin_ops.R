#' CKAN task status maintenance
#'
#' These helpers wrap the sysadmin-only task status endpoints that CKAN uses to
#' track background operations (eg DataPusher runs).
#'
#' @name task_status
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-ckan-key")
#' task_status_show(entity_type = "dataset", entity_id = "my-dataset")
#' task_status_update(
#'   entity_id = "my-dataset",
#'   entity_type = "dataset",
#'   task_type = "datapusher",
#'   task_key = "default",
#'   value = "queued",
#'   state = "running"
#' )
#' }
NULL

#' @rdname task_status
#' @template args
#' @template key
#' @export
task_status_show <- function(id = NULL, entity_id = NULL, entity_type = NULL,
  task_type = NULL, task_key = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(
    id = id,
    entity_id = entity_id,
    entity_type = entity_type,
    task_type = task_type,
    key = task_key
  ))
  res <- ckan_GET(url, 'task_status_show', args, key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname task_status
#' @template args
#' @template key
#' @export
task_status_update <- function(id = NULL, entity_id = NULL,
  entity_type = NULL, task_type = NULL, task_key = NULL, value = NULL,
  state = NULL, last_updated = NULL, error = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  body <- cc(list(
    id = id,
    entity_id = entity_id,
    entity_type = entity_type,
    task_type = task_type,
    key = task_key,
    value = value,
    state = state,
    last_updated = last_updated,
    error = error
  ))
  res <- ckan_POST(url, 'task_status_update', body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname task_status
#' @template args
#' @template key
#' @param data (list) For `task_status_update_many()`, a list of task status
#'   dictionaries to update.
#' @export
task_status_update_many <- function(data, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  if (!is.list(data) || !length(data)) {
    stop("`data` must be a non-empty list of task dictionaries", call. = FALSE)
  }
  payload <- tojun(list(data = data))
  res <- ckan_POST(url, 'task_status_update_many', body = payload, key = key,
    headers = ctj(), opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname task_status
#' @template args
#' @template key
#' @export
task_status_delete <- function(id = NULL, entity_id = NULL,
  entity_type = NULL, task_type = NULL, task_key = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  body <- cc(list(
    id = id,
    entity_id = entity_id,
    entity_type = entity_type,
    task_type = task_type,
    key = task_key
  ))
  res <- ckan_POST(url, 'task_status_delete', body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Term translation helpers
#'
#' Manage localized UI strings stored in CKAN's term translation table.
#'
#' @name term_translation
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-ckan-key")
#' term_translation_show(c("License", "Dataset"), lang_codes = "fr")
#' term_translation_update(term = "License", term_translation = "Licence", lang_code = "fr")
#' }
NULL

#' @rdname term_translation
#' @template args
#' @template key
#' @param terms (character) Vector of source terms.
#' @param lang_codes (character) Language codes to include.
#' @export
term_translation_show <- function(terms, lang_codes = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  args <- cc(list(terms = as.list(terms), lang_codes = as.list(lang_codes)))
  res <- ckan_GET(url, 'term_translation_show', args, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname term_translation
#' @template args
#' @template key
#' @param term (character) Source term.
#' @param term_translation (character) Translation value.
#' @param lang_code (character) Target language code.
#' @export
term_translation_update <- function(term, term_translation, lang_code,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  body <- list(term = term, term_translation = term_translation,
    lang_code = lang_code)
  res <- ckan_POST(url, 'term_translation_update', body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname term_translation
#' @template args
#' @template key
#' @export
term_translation_update_many <- function(data, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  if (!is.list(data) || !length(data)) {
    stop("`data` must be a non-empty list of translation dictionaries", call. = FALSE)
  }
  payload <- tojun(list(data = data))
  res <- ckan_POST(url, 'term_translation_update_many', body = payload,
    key = key, headers = ctj(), opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Runtime configuration helpers
#'
#' Inspect and update CKAN's runtime-editable configuration keys.
#'
#' @name config_options
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-ckan-key")
#' config_option_list()
#' config_option_update(list("ckan.site_title" = "My Portal"))
#' }
NULL

#' @rdname config_options
#' @template args
#' @template key
#' @export
config_option_list <- function(url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  res <- ckan_GET(url, 'config_option_list', list(), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname config_options
#' @template args
#' @template key
#' @param option_key (character) Configuration option identifier.
#' @export
config_option_show <- function(option_key, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  res <- ckan_GET(url, 'config_option_show', list(key = option_key), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname config_options
#' @template args
#' @template key
#' @param options (list) Named list of configuration options to update.
#' @export
config_option_update <- function(options, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  if (missing(options) || !length(options)) {
    stop("options must be a named list", call. = FALSE)
  }
  res <- ckan_POST(url, 'config_option_update', body = options, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Background job helpers
#'
#' Manage CKAN's RQ/Redis job queue (requires sysadmin access).
#'
#' @name job_queue
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-ckan-key")
#' job_list()
#' }
NULL

#' @rdname job_queue
#' @template args
#' @template key
#' @param queues (character) Queue names to target.
#' @export
job_list <- function(queues = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  payload <- list(queues = if (is.null(queues)) list() else queues)
  payload <- tojun(payload)
  res <- ckan_POST(url, 'job_list', body = payload, key = key,
    headers = ctj(), opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname job_queue
#' @template args
#' @template key
#' @param id (character) Job identifier.
#' @export
job_show <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_GET(url, 'job_show', list(id = id), key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname job_queue
#' @template args
#' @template key
#' @export
job_clear <- function(queues = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  payload <- list(queues = if (is.null(queues)) list() else queues)
  payload <- tojun(payload)
  res <- ckan_POST(url, 'job_clear', body = payload, key = key,
    headers = ctj(), opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname job_queue
#' @template args
#' @template key
#' @export
job_cancel <- function(id, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  payload <- tojun(list(id = id))
  res <- ckan_POST(url, 'job_cancel', body = payload, key = key,
    headers = ctj(), opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' API token helpers
#'
#' Inspect, create, and revoke API tokens for a user.
#'
#' @name api_tokens
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-ckan-key")
#' api_token_list(user_id = "my-user-id")
#' }
NULL

#' @rdname api_tokens
#' @template args
#' @template key
#' @param user_id (character) User identifier to filter tokens.
#' @export
api_token_list <- function(user_id = NULL, url = get_default_url(),
  key = get_default_key(), as = 'list', ...) {

  args <- cc(list(user_id = user_id))
  res <- ckan_GET(url, 'api_token_list', args, key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname api_tokens
#' @template args
#' @template key
#' @param user (character) Name or id of the token owner.
#' @param name (character) Friendly token name.
#' @param extra_fields (list) Optional named list of additional fields accepted
#'   by CKAN or extensions.
#' @export
api_token_create <- function(user, name, extra_fields = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  body <- list(user = user, name = name)
  if (!is.null(extra_fields)) {
    stopifnot(is.list(extra_fields))
    body <- c(body, extra_fields)
  }
  res <- ckan_POST(url, 'api_token_create', body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname api_tokens
#' @template args
#' @template key
#' @param token (character) Encoded API token value.
#' @param jti (character) Token identifier (overrides `token` when provided).
#' @export
api_token_revoke <- function(token = NULL, jti = NULL,
  url = get_default_url(), key = get_default_key(), as = 'list', ...) {

  if (is.null(token) && is.null(jti)) {
    stop("Provide either token or jti", call. = FALSE)
  }
  body <- cc(list(token = token, jti = jti))
  res <- ckan_POST(url, 'api_token_revoke', body = body, key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' Diagnostics helpers
#'
#' Lightweight wrappers for CKAN's `status_show` and `help_show` actions.
#'
#' @name diagnostics
#' @examples
#' \\dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/")
#' status_show()
#' help_show("package_search")
#' }
NULL

#' @rdname diagnostics
#' @template args
#' @template key
#' @export
status_show <- function(url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_GET(url, 'status_show', list(), key = key, opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}

#' @rdname diagnostics
#' @template args
#' @template key
#' @param name (character) CKAN action name to describe.
#' @export
help_show <- function(name, url = get_default_url(), key = get_default_key(),
  as = 'list', ...) {

  res <- ckan_GET(url, 'help_show', list(name = name), key = key,
    opts = list(...))
  switch(as, json = res, list = jsl(res), table = jsd(res))
}
