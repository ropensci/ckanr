#' Connect to CKAN with dplyr
#'
#' Use `src_ckan` to connect to an existing CKAN instance and `tbl` to
#' connect to tables within that CKAN based on the DataStore Data API.
#' 
#' The function returns a 
#' [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/DBIConnection-class.html) 
#' object, which can be then used by 
#' [dbplyr](https://dbplyr.tidyverse.org/articles/dbplyr.html) and
#' 
#'
#' @param url, the url of the CKAN instance
#' @examples \dontrun{
#' # To connect to a CKAN instance first create a src:
#' my_ckan <- src_ckan("https://www.data.qld.gov.au/")
#' 
#' summary(my_ckan)
#' dplyr::db_desc(my_ckan)
#' 
#' # dplyr has changed its dbplyr backend API to version 2
#' dbplyr::dbplyr_edition(my_ckan)
#'
#' # List all tables in the CKAN database
#' tbl_list <- DBI::dbListTables(my_ckan, limit=5)
#' tbl_list
#'
#' # Create an in-memory table from a CKAN database table
#' tbl1 <- dplyr::tbl(my_ckan, tbl_list[1])
#' tbl2 <- dplyr::tbl(my_ckan, "587f65ae-6675-4b8e-bac5-606ce7f4446a")
#'
#' # You can use the dplyr verbs with tbl. For example:
#' dplyr::filter(tbl1, variable_name == "value")
#' dplyr::select(tbl2, `Density class`, Full)
#' }
#' @aliases dplyr-interface
#' @export
src_ckan <- function(url) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Please install dplyr", call. = FALSE)
  }
  
  drv <- new("CKANDriver")
  DBI::dbConnect(drv, url = url)
}

#' An implementation of `dplyr::tbl()` for `ckanr`
#' 
#' This implementation converts the `DBI::dbConnect()` connection returned by
#' `ckanr::src_ckan()` into a structure that nests the connection under a key
#' `con`. This is expected by `dbplyr::tbl_sql()`.
#' 
#' @param src A `DBI::dbConnect()` database connection.
#' @param name The table name which will be used as the SQL FROM clause. 
#' This is vulnerable to SQL injections, so use only with known safe names, 
#' e.g. CKAN resource IDs.
#' @param ... Extra arguments will be passed on to `dbplyr::tbl_sql()`.
#' @export
#' @importFrom dplyr tbl
#' @importFrom dbplyr tbl_sql sql
tbl.src_ckan <- function(src, name, ...) {
  dplyr_src = structure(list(con=src))
  dbplyr::tbl_sql(
    subclass = "CKANConnection",
    src = dplyr_src,
    from = dbplyr::sql(sprintf('SELECT * FROM "%s"', name)),
    ...
  )
}

#' An implementation of `dplyr::tbl()` for `ckanr`
#' 
#' This implementation converts the `DBI::dbConnect()` connection returned by
#' `ckanr::src_ckan()` into a structure that nests the connection under a key
#' `con`. This is expected by `dbplyr::tbl_sql()`.
#' 
#' @param src A dplyr data source
#' @param name The table name. If given, `from` will be ignored, and the name
#' will be used as string. This is vulnerable to SQL injections, so use only
#' with known safe names, e.g. CKAN resource IDs.
#' @param ... Extra arguments will be passed on to `dbplyr::tbl_sql()`. 
#' @export
#' @importFrom dplyr tbl
#' @importFrom dbplyr tbl_sql sql
tbl.CKANConnection <- function(src, name, ...) {
  tbl.src_ckan(src, name, ...)
}

#' @export
#' @importFrom dplyr db_desc
db_desc.CKANConnection <- function(x) {
  sprintf("CKAN URL: %s", x@url)
}

#' @export
#' @importFrom dplyr src_tbls
src_tbls.CKANConnection <- function(x, ..., limit = 6) {
  if (!is.null(limit)) {
    c(dbListTables(x, limit = limit))
  } else {
    dbListTables(x)
  }
}

#' @export
format.CKANConnection <- function(x, ...) {
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
#' @importFrom dbplyr base_agg build_sql
sql_translation.src_ckan <- function(con) {
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
sql_translation.CKANConnection <- function(con) {
  sql_translation.src_ckan(con)
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
#' @importFrom dbplyr sql_query_explain
sql_query_explain.CKANConnection <- function(con, sql, format = "text", ...) {
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
sql_query_fields.CKANConnection <- function(con, sql, ...) {
  sql <- sql_query_select(con, sql("*"), sql_query_wrap(con, sql), where = sql("0 = 1"))
  qry <- dbSendQuery(con, sql)
  on.exit(dbClearResult(qry))

  res <- fetch(qry, 0)
  names(res)
}

#' @export
#' @importFrom dplyr db_query_rows
db_query_rows.CKANConnection <- function(con, sql, ...) {
  from <- sql_query_wrap(con, sql, "master")
  # rows <- build_sql("SELECT count(*) FROM ", from, con = con)
  rows <- sprintf("SELECT count(*) FROM (%s)", unclass(sql))
  as.integer(dbGetQuery(con$con, rows)[[1]])
}

#' Use dbplyr 2.0.0 generics
#' See https://dbplyr.tidyverse.org/articles/backend-2.html#nd-edition
#' Introduced in 0.8.0
#' @param con A database connection.
#' @importFrom dbplyr dbplyr_edition
#' @export
dbplyr_edition.CKANConnection <- function(con) 2L

#' @importFrom dplyr db_list_tables
#' @importFrom dbplyr base_agg base_scalar base_win build_sql sql sql_prefix 
#' sql_translator sql_variant src_sql tbl_sql
#' sql_query_fields sql_query_select sql_query_wrap sql_query_explain sql_translation
NULL
