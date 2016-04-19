#' Connect to CKAN with dplyr
#'
#' Use \code{src_ckan} to connect to an existing CKAN instance and \code{tbl} to
#' connect to tables within that CKAN based on the DataStore Data API.
#'
#' @param url, the url of the CKAN instance
#' @examples
#' \dontrun{
#' # To connect to a CKAN instance first create a src:
#' my_ckan <- src_ckan("http://demo.ckan.org")
#'
#' # List all tables in the CKAN instance
#' db_list_tables(my_ckan$con)
#'
#' # Then reference a tbl within that src
#' my_tbl <- tbl(my_ckan, name = "be2ccdc2-9a76-47bf-862c-60c1525f5b1b")
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
    tbl_sql("ckan", src = src, from = sql(sprintf('SELECT * FROM "%s"', name)))
  }
}

#'@export
#'@importFrom dplyr src_desc
src_desc.src_ckan <- function(x) {
  info <- x$info
  sprintf("ckan url: %s", x$con@url)
}

#'@export
#'@importFrom dplyr src_tbls
src_tbls.src_ckan <- function(x, ..., limit = 6) {
  if (!is.null(limit)) {
    c(dbListTables(x$con, limit = limit))
  } else {
    dbListTables(x$con)
  }
}

#'@export
format.src_ckan <- function(x, ...) {
  .metadata <- ds_search("_table_metadata", url = x$con@url, limit = 6)
  x1 <- sprintf("%s", src_desc(x))
  x2 <- sprintf("total tbls: %d", .metadata$total)
  if (.metadata$total > 6) {
    x3 <- sprintf("tbls: %s, ...", paste0(sort(sapply(.metadata$records, "[[", "name")), collapse = ", "))
  } else {
    x3 <- sprintf("tbls: %s", paste0(sort(sapply(.metadata$records, "[[", "name")), collapse = ", "))
  }
  paste(x1, x2, x3, sep = "\n")
}

#'@export
#'@importFrom dplyr src_translate_env
src_translate_env.src_ckan <- function(x) {
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
      paste = function(x, collapse) build_sql("string_agg(", x, ", ", collapse, ")")
    ),
    base_win
  )
}


#'@export
#'@importFrom dplyr db_has_table
db_has_table.CKANConnection <- function(con, table, ...) {
  table %in% db_list_tables(con)
}

#'@export
#'@importFrom dplyr db_begin
db_begin.CKANConnection <- function(con, ...) {
  dbGetQuery(con, "BEGIN TRANSACTION")
}

# http://www.postgresql.org/docs/9.3/static/sql-explain.html
#'@export
#'@importFrom dplyr db_explain
db_explain.CKANConnection <- function(con, sql, format = "text", ...) {
  format <- match.arg(format, c("text", "json", "yaml", "xml"))

  exsql <- build_sql("EXPLAIN ",
    if (!is.null(format)) build_sql("(FORMAT ", sql(format), ") "),
    sql)
  expl <- dbGetQuery(con, exsql)

  paste(expl[[1]], collapse = "\n")
}

#'@export
#'@importFrom dplyr db_insert_into
db_insert_into.CKANConnection <- function(con, table, values, ...) {
  .read_only("db_insert_into.CKANConnection")
}
