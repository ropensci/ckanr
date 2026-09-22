#' Connect to CKAN with dplyr
#'
#' Use `src_ckan` to connect to an existing CKAN instance. Use `tbl` to
#' connect to tables in that CKAN through the DataStore Data API.
#'
#' @param url The url of the CKAN instance
#' @param key An optional CKAN API key
#' @examples \dontrun{
#' library("dplyr")
#'
#' # To connect to a CKAN instance first create a src:
#' my_ckan <- src_ckan("http://demo.ckan.org")
#'
#' # The primary dbplyr interface uses the DBI connection directly
#' con <- my_ckan$con
#' dplyr::tbl(con, "resource-id") |>
#'   dplyr::filter(status == "active") |>
#'   dplyr::collect()
#'
#' # List all tables in the CKAN instance
#' DBI::dbListTables(con)
#'
#' # `src_ckan()` remains available for existing code
#' my_tbl <- dplyr::tbl(
#'   my_ckan,
#'   name = "44d7de5f-7029-4f3a-a812-d7a70895da7d"
#' )
#'
#' # You can use the dplyr verbs with my_tbl. For example:
#' dplyr::filter(my_tbl, GABARITO == "C")
#'
#' # The DataStore interface is read-only. `collect()` retrieves the result
#' # from CKAN. Filter or limit large tables before collecting them.
#' }
#' @aliases dplyr-interface
#' @export
src_ckan <- function(url, key = get_default_key()) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Please install dplyr", call. = FALSE)
  }
  if (!requireNamespace("dbplyr", quietly = TRUE)) {
    stop("Please install dbplyr", call. = FALSE)
  }
  drv <- new("CKANDriver")
  con <- dbConnect(drv, url = url, key = key)
  info <- dbGetInfo(con)
  src <- dbplyr::src_dbi(con)
  src$info <- info
  class(src) <- unique(c("src_ckan", class(src)))
  src
}

# dbplyr's second-edition backend API is selected by this method.
# The DataStore speaks a restricted, read-only PostgreSQL dialect.
#' @exportS3Method dbplyr::dbplyr_edition
dbplyr_edition.CKANConnection <- function(con) 2L

#' @exportS3Method dbplyr::sql_dialect
sql_dialect.CKANConnection <- function(con) {
  dbplyr::new_sql_dialect(
    "ckan",
    quote_identifier = function(x) DBI::dbQuoteIdentifier(con, x)
  )
}

#' @exportS3Method dbplyr::db_connection_describe
db_connection_describe.CKANConnection <- function(con, ...) {
  sprintf("CKAN DataStore (%s)", con@url)
}

#' @exportS3Method dbplyr::sql_translation
sql_translation.sql_dialect_ckan <- function(con) {
  dbplyr::sql_variant(
    dbplyr::sql_translator(
      .parent = dbplyr::base_scalar
    ),
    dbplyr::sql_translator(
      .parent = dbplyr::base_agg,
      cor = dbplyr::sql_aggregate_2("CORR"),
      cov = dbplyr::sql_aggregate_2("COVAR_SAMP"),
      sd = dbplyr::sql_aggregate("STDDEV_SAMP", "sd"),
      var = dbplyr::sql_aggregate("VAR_SAMP", "var"),
      all = dbplyr::sql_aggregate("BOOL_AND", "all"),
      any = dbplyr::sql_aggregate("BOOL_OR", "any"),
      paste = dbplyr::sql_paste(" ")
    ),
    dbplyr::sql_translator(
      .parent = dbplyr::base_win,
      paste = dbplyr::win_aggregate("STRING_AGG")
    )
  )
}

# The DataStore Action API does not accept EXPLAIN or CREATE TABLE statements.
# Fail before sending those statements to CKAN.
#' @exportS3Method dbplyr::sql_query_explain
sql_query_explain.sql_dialect_ckan <- function(con, sql, ...) {
  stop("EXPLAIN is not supported by the CKAN DataStore SQL API", call. = FALSE)
}

#' @exportS3Method dbplyr::sql_query_save
sql_query_save.sql_dialect_ckan <- function(con, sql, name, temporary = TRUE, ...) {
  stop("The CKAN DataStore interface is read-only", call. = FALSE)
}

#' @export
#' @importFrom dplyr tbl
tbl.src_ckan <- function(src, from, ..., name = NULL) {
  if (is.null(name)) {
    dplyr::tbl(src$con, from = dbplyr::sql(from), ...)
  } else {
    dplyr::tbl(src$con, name, ...)
  }
}

#' @exportS3Method dplyr::db_desc
db_desc.src_ckan <- function(x) {
  info <- x$info
  sprintf("ckan url: %s", x$con@url)
}

#' @export
#' @importFrom dplyr src_tbls
src_tbls.src_ckan <- function(x, ..., limit = 6) {
  if (!is.null(limit)) {
    c(dbListTables(x$con, limit = limit))
  } else {
    dbListTables(x$con)
  }
}

#' @export
format.src_ckan <- function(x, ...) {
  .metadata <- ds_search(
    "_table_metadata", url = x$con@url, key = x$con@key, limit = 6
  )
  x1 <- sprintf("%s", dplyr::db_desc(x))
  x2 <- sprintf("total tbls: %d", .metadata$total)
  if (.metadata$total > 6) {
    x3 <- sprintf(
      "tbls: %s, ...",
      paste0(sort(sapply(.metadata$records, "[[", "name")),
        collapse = ", "
      )
    )
  } else {
    x3 <- sprintf(
      "tbls: %s",
      paste0(sort(sapply(.metadata$records, "[[", "name")),
        collapse = ", "
      )
    )
  }
  paste(x1, x2, x3, sep = "\n")
}

#' @importFrom dplyr src_tbls
#' @importFrom dbplyr base_agg base_scalar base_win sql_aggregate sql_aggregate_2 sql_paste win_aggregate
#' @importFrom dbplyr new_sql_dialect sql_dialect sql_query_explain sql_query_save
#' @importFrom dbplyr sql_translation sql_translator sql_variant
NULL
