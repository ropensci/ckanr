#' File management
#'
#' These helpers wrap CKAN 2.12 `file_*` endpoints. Files are first-class
#' entities in CKAN 2.12 (see
#' <https://docs.ckan.org/en/2.12/api/#ckan-logic-action-file> and
#' <https://github.com/ckan/ckan/pull/9026>). The target CKAN instance must
#' run CKAN 2.12 or later; each wrapper calls `ensure_action_available()`
#' so it fails clearly on older instances.
#'
#' By default only sysadmins may call `file_create()`; see
#' `ckan.files.authenticated_uploads.allow` in the CKAN docs for granting
#' access to registered users.
#'
#' @name files
#' @template args
#' @template key
#' @param id (character or `ckan_file`) File identifier.
#' @param name (character) Human-readable file name. For `file_create()`,
#'   defaults to the uploaded file's name when `upload` is a local path.
#' @param storage (character) Name of the storage handling the upload.
#'   Defaults to the configured `default` storage.
#' @param upload (character) Local path of the file to upload for
#'   `file_create()`. Required.
#' @param location (character) Location of the file in the storage for
#'   `file_register()`. Required.
#' @param owner_id (character) ID of the new owner for
#'   `file_ownership_transfer()` and `file_owner_scan()`.
#' @param owner_type (character) Type of the new owner (for example
#'   `"package"`, `"user"`, `"group"`, `"organization"`).
#' @param force (logical) For `file_ownership_transfer()`, move the file
#'   even if it is pinned. Default: `FALSE`.
#' @param pin (logical) For `file_ownership_transfer()`, pin the file after
#'   transfer to stop future transfers. Default: `FALSE`.
#' @param start (numeric) Index of the first row for `file_owner_scan()`.
#' @param rows (numeric) Number of rows to return for `file_owner_scan()`.
#' @param sort (character) `File` column used for sorting in
#'   `file_owner_scan()`. Optional; when `NULL` the server default
#'   (`"name"`) applies.
NULL

coerce_file <- function(res) as_ck(res, "ckan_file")

#' @rdname files
#' @export
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = getOption("ckan_demo_key"))
#' f <- file_create(upload = "path/to/file.csv")
#' file_show(f$id)
#' }
file_create <- function(
  upload, name = NULL, storage = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_create", url = url, key = key)
  if (missing(upload) || is.null(upload)) {
    stop("`upload` must be a path to a local file", call. = FALSE)
  }
  if (!is.character(upload) || length(upload) != 1L) {
    stop("`upload` must be a single file path", call. = FALSE)
  }
  if (!file.exists(upload)) {
    stop(sprintf("`upload` file does not exist: %s", upload), call. = FALSE)
  }
  if (is.null(name)) {
    name <- basename(upload)
  }
  body <- cc(list(
    name = name,
    storage = storage,
    upload = upfile(upload)
  ))
  out <- ckan_POST(url, "file_create",
    body = body, key = key, opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_register <- function(
  location = NULL, storage = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_register", url = url, key = key)
  if (is.null(location) || !nzchar(location[1])) {
    stop("`location` must be a non-empty string", call. = FALSE)
  }
  body <- cc(list(location = location, storage = storage))
  out <- ckan_POST(url, "file_register",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_show <- function(
  id, url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_show", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  out <- ckan_GET(url, "file_show", list(id = id),
    key = key, opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_delete <- function(
  id, url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_delete", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  out <- ckan_POST(url, "file_delete",
    body = tojun(list(id = id), TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_rename <- function(
  id, name, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_rename", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  body <- list(id = id, name = name)
  out <- ckan_POST(url, "file_rename",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_pin <- function(
  id, url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_pin", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  out <- ckan_POST(url, "file_pin",
    body = tojun(list(id = id), TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_unpin <- function(
  id, url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_unpin", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  out <- ckan_POST(url, "file_unpin",
    body = tojun(list(id = id), TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_ownership_transfer <- function(
  id, owner_id, owner_type, force = FALSE, pin = FALSE,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_ownership_transfer", url = url, key = key)
  if (inherits(id, "ckan_file")) id <- id$id
  body <- list(
    id = id, owner_id = owner_id, owner_type = owner_type,
    force = force, pin = pin
  )
  out <- ckan_POST(url, "file_ownership_transfer",
    body = tojun(body, TRUE), key = key,
    headers = ctj(), encode = "json", opts = list(...)
  )
  parse_ckan_response(out, as, list_coercer = coerce_file)
}

#' @rdname files
#' @export
file_owner_scan <- function(
  owner_id, owner_type, start = NULL, rows = NULL, sort = NULL,
  url = get_default_url(), key = get_default_key(), as = "list", ...
) {
  ensure_action_available("file_owner_scan", url = url, key = key)
  args <- cc(list(
    owner_id = owner_id, owner_type = owner_type,
    start = start, rows = rows, sort = sort
  ))
  out <- ckan_GET(url, "file_owner_scan", args,
    key = key, opts = list(...)
  )
  parse_ckan_response(out, as)
}
