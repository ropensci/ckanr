#' Datastore write helpers (CKAN 2.12+ parameters from the start)
#'
#' Wrappers for `datastore_upsert`, `datastore_delete`,
#' `datastore_records_delete`, `datastore_info`, `datastore_function_create`,
#' `datastore_function_delete`, and `datastore_run_triggers`. `ds_search()`
#' and `ds_create()` cover read/create; these helpers complete the
#' write/info coverage with the CKAN 2.12 parameters (`include_records`,
#' `include_meta`, `include_fields_schema`, `argmode`) available from the
#' start. See
#' <https://docs.ckan.org/en/2.12/maintaining/datastore.html#the-data-api>.
#'
#' @name datastore_extra
#' @template args
#' @template key
#' @param resource_id (character) Resource id that the data is stored against.
#' @param records (list|data.frame) The data, e.g.
#' `list(list(a = 1, b = "xyz"))`.
#' @param force (logical) Edit a read-only table. Default: `FALSE`.
#' @param method (character) Upsert method: `"upsert"` (default),
#' `"insert"`, or `"update"`. `upsert`/`update` require a unique key or
#' `_id` field.
#' @param filters (list|character) Matching conditions to select, e.g.
#' `list(name = "fred")`. CKAN 2.12+ accepts advanced syntax (ranges, nested
#' AND/OR); the argument passes through untouched.
#' @param include_records (logical) If `TRUE`, return the actual affected
#' rows in the response (CKAN 2.12+). Default: `FALSE`.
#' @param include_deleted_records (logical) If `TRUE`, return the full
#' values of deleted records (CKAN 2.12+). Default: `FALSE`.
#' @param calculate_record_count (logical|character) `FALSE` skips the
#' count update, `TRUE` updates immediately, `"background"` schedules a
#' background job (default).
#' @param dry_run (logical) Abort the transaction instead of committing,
#' e.g. to check validation errors. Default: `FALSE`.
#' @param include_meta (logical) For `ds_info()`, return table size, index
#' size, row count and aliases (CKAN 2.12+). Default: `TRUE`.
#' @param include_fields_schema (logical) For `ds_info()`, return per-field
#' index/unique/notnull status (CKAN 2.12+). Default: `TRUE`.
#' @param name (character) Trigger function name for
#' `ds_function_create()` / `ds_function_delete()`.
#' @param or_replace (logical) Replace the function if it exists.
#' Default: `FALSE`.
#' @param rettype (character) Set to `"trigger"` (only trigger functions
#' may be created at this time).
#' @param definition (character) PL/pgSQL function body for the trigger.
#' @param argmode (character) Argument mode for custom DataStore SQL
#' function parameters, e.g. `"in"`, `"inout"`, `"out"` (CKAN 2.12+,
#' <https://github.com/ckan/ckan/pull/8279>). Optional.
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#' ds_info(resource_id = "my-resource-id")
#' ds_upsert(resource_id = "my-resource-id",
#'   records = list(list(a = 1, b = "xyz")), method = "upsert")
#' }
NULL

datastore_body_post <- function(action, body, url, key, as, opts) {
  headers <- c(auth_headers(key), ctj())
  con <- crul::HttpClient$new(file.path(notrail(url), "api/action", action),
    headers = headers,
    opts = opts
  )
  res <- con$post(body = tojun(body, TRUE), encode = "json")
  err_handler(res)
  txt <- res$parse("UTF-8")
  switch(as,
    json = txt,
    list = jsl(txt),
    table = jsd(txt)
  )
}

#' @rdname datastore_extra
#' @export
ds_upsert <- function(
  resource_id, records = NULL, method = "upsert", force = FALSE,
  include_records = FALSE, calculate_record_count = "background",
  dry_run = FALSE, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  if (!method %in% c("upsert", "insert", "update")) {
    stop('`method` must be one of "upsert", "insert", "update"', call. = FALSE)
  }
  body <- cc(list(
    resource_id = resource_id, records = records, method = method,
    force = force,
    include_records = if (isTRUE(include_records)) TRUE else NULL,
    calculate_record_count = calculate_record_count,
    dry_run = if (isTRUE(dry_run)) TRUE else NULL
  ))
  datastore_body_post("datastore_upsert", body, url, key, as, list(...))
}

#' @rdname datastore_extra
#' @export
ds_delete <- function(
  resource_id = NULL, filters = NULL, force = FALSE,
  include_deleted_records = FALSE, calculate_record_count = "background",
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  body <- cc(list(
    resource_id = resource_id, filters = filters, force = force,
    include_deleted_records = if (isTRUE(include_deleted_records)) TRUE else NULL,
    calculate_record_count = calculate_record_count
  ))
  datastore_body_post("datastore_delete", body, url, key, as, list(...))
}

#' @rdname datastore_extra
#' @export
ds_records_delete <- function(
  resource_id, filters, force = FALSE,
  include_deleted_records = FALSE, calculate_record_count = "background",
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  body <- cc(list(
    resource_id = resource_id, filters = filters, force = force,
    include_deleted_records = if (isTRUE(include_deleted_records)) TRUE else NULL,
    calculate_record_count = calculate_record_count
  ))
  datastore_body_post("datastore_records_delete", body, url, key, as, list(...))
}

#' @rdname datastore_extra
#' @export
ds_info <- function(
  resource_id, include_meta = TRUE, include_fields_schema = TRUE,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  args <- cc(list(
    resource_id = resource_id,
    include_meta = if (isFALSE(include_meta)) FALSE else NULL,
    include_fields_schema = if (isFALSE(include_fields_schema)) FALSE else NULL
  ))
  res <- ckan_GET(url, "datastore_info", args, key = key, opts = list(...))
  switch(as,
    json = res,
    list = jsl(res),
    table = jsd(res)
  )
}

#' @rdname datastore_extra
#' @export
ds_function_create <- function(
  name, rettype = "trigger", definition, or_replace = FALSE,
  argmode = NULL, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  body <- cc(list(
    name = name, rettype = rettype, definition = definition,
    or_replace = or_replace, argmode = argmode
  ))
  datastore_body_post("datastore_function_create", body, url, key, as, list(...))
}

#' @rdname datastore_extra
#' @export
ds_function_delete <- function(
  name, url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  body <- list(name = name)
  datastore_body_post("datastore_function_delete", body, url, key, as, list(...))
}

#' @rdname datastore_extra
#' @export
ds_run_triggers <- function(
  resource_id, url = get_default_url(), key = get_default_key(),
  as = "list", ...
) {
  body <- list(resource_id = resource_id)
  datastore_body_post("datastore_run_triggers", body, url, key, as, list(...))
}
