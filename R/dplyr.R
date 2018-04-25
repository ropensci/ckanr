#' Connect to CKAN with dplyr
#'
#' Use \code{src_ckan} to connect to an existing CKAN instance and \code{tbl} to
#' connect to tables within that CKAN based on the DataStore Data API.
#'
#' @param url, the url of the CKAN instance
#' @examples \dontrun{
#' library("dplyr")
#'
#' # To connect to a CKAN instance first create a src:
#' my_ckan <- src_ckan("http://demo.ckan.org")
#'
#' # List all tables in the CKAN instance
#' db_list_tables(my_ckan$con)
#'
#' # Then reference a tbl within that src
#' my_tbl <- tbl(src = my_ckan, name = "44d7de5f-7029-4f3a-a812-d7a70895da7d")
#'
#' # You can use the dplyr verbs with my_tbl. For example:
#' dplyr::filter(my_tbl, GABARITO == "C")
#'
#' }
#' @aliases dplyr-interface
#' @export
src_ckan <- function(url) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Please install dplyr", call. = FALSE)
  }
  drv <- new("CKANDriver")
  con <- dbConnect(drv, url = url)
  info <- dbGetInfo(con)
  src_sql("ckan", con, info = info)
}

#'@export
#'@importFrom dplyr tbl
tbl.src_ckan <- function(src, from, ..., name = NULL) {
  if (is.null(name)) {
    tbl_sql("ckan", src = src, from = sql(from), ...)
  } else {
    tbl_sql(subclass = "ckan",
            src = src,
            from = sql(sprintf('SELECT * FROM "%s"', name)))
  }
}

#' @importFrom dplyr db_desc
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
  .metadata <- ds_search("_table_metadata", url = x$con@url, limit = 6)
  x1 <- sprintf("%s", db_desc(x))
  x2 <- sprintf("total tbls: %d", .metadata$total)
  if (.metadata$total > 6) {
    x3 <- sprintf("tbls: %s, ...",
                  paste0(sort(sapply(.metadata$records, "[[", "name")),
                         collapse = ", "))
  } else {
    x3 <- sprintf("tbls: %s",
                  paste0(sort(sapply(.metadata$records, "[[", "name")),
                         collapse = ", "))
  }
  paste(x1, x2, x3, sep = "\n")
}

#' @export
#' @importFrom dplyr sql_translate_env
#' @importFrom dbplyr base_agg build_sql
sql_translate_env.src_ckan <- function(x) {
  sql_variant(
    base_scalar,
    sql_translator(.parent = base_agg,
                   n = function() sql("count(*)"),
                   cor = sql_prefix("corr"),
                   cov = sql_prefix("covar_samp"),
                   sd =  sql_prefix("stddev_samp"),
                   var = sql_prefix("var_samp"),
                   all = sql_prefix("bool_and"),
                   any = sql_prefix("bool_or"),
                   paste = function(x, collapse) {
                     build_sql("string_agg(", x, ", ", collapse, ")")
                   }
    ),
    base_win
  )
}

#' @export
sql_translate_env.CKANConnection <- function(con) {
  sql_translate_env.src_ckan(con)
}

#' @export
#' @importFrom dplyr db_has_table
db_has_table.CKANConnection <- function(con, table, ...) {
  table %in% db_list_tables(con)
}

#' @export
#' @importFrom dplyr db_begin
db_begin.CKANConnection <- function(con, ...) {
  dbGetQuery(con, "BEGIN TRANSACTION")
}

# http://www.postgresql.org/docs/9.3/static/sql-explain.html
#' @export
#' @importFrom dplyr db_explain
db_explain.CKANConnection <- function(con, sql, format = "text", ...) {
  format <- match.arg(format, c("text", "json", "yaml", "xml"))

  exsql <- build_sql("EXPLAIN ",
                     if (!is.null(format)) build_sql("(FORMAT ", sql(format), ") "),
                     sql)
  expl <- dbGetQuery(con, exsql)

  paste(expl[[1]], collapse = "\n")
}

#' @export
#' @importFrom dplyr db_insert_into
db_insert_into.CKANConnection <- function(con, table, values, ...) {
  .read_only("db_insert_into.CKANConnection")
}

#' @export
#' @importFrom dplyr db_query_fields
db_query_fields.CKANConnection <- function(con, sql, ...) {
  sql <- sql_select(con, sql("*"), sql_subquery(con, sql), where = sql("0 = 1"))
  qry <- dbSendQuery(con, sql)
  on.exit(dbClearResult(qry))

  res <- fetch(qry, 0)
  names(res)
}

#' @export
#' @importFrom dplyr db_query_rows
db_query_rows.CKANConnection <- function(con, sql, ...) {
  from <- sql_subquery(con, sql, "master")
  # rows <- build_sql("SELECT count(*) FROM ", from, con = con)
  rows <- sprintf("SELECT count(*) FROM (%s)", unclass(sql))
  as.integer(dbGetQuery(con$con, rows)[[1]])
}

#' @importFrom dplyr db_list_tables sql sql_select sql_subquery
#' @importFrom dbplyr base_agg base_scalar base_win build_sql sql_prefix
#' sql_translator sql_variant src_sql tbl_sql
NULL
