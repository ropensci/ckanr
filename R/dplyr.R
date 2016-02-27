#'@export
src_ckan <- function(url) {
  library(dplyr)
  drv <- new("CKANDriver")
  con <- dbConnect(drv, url = url)
  info <- dbGetInfo(con)
  src_sql("ckan", con, info = info)
}

#'@export
tbl.src_ckan <- function(src, from, ..., name = NULL) {
  if (is.null(name)) {
    tbl_sql("ckan", src = src, from = sql(from), ...)
  } else {
    tbl_sql("ckan", src = src, from = sql(sprintf('SELECT * FROM "%s"', name)))
  }
}

#'@export
src_desc.src_ckan <- function(x) {
  info <- x$info
  sprintf("ckan url: %s", src$con@url)
}

#'@export
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

#' @export
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


#' @export
db_has_table.CKANConnection <- function(con, table, ...) {
  table %in% db_list_tables(con)
}

#' @export
db_begin.CKANConnection <- function(con, ...) {
  dbGetQuery(con, "BEGIN TRANSACTION")
}

# http://www.postgresql.org/docs/9.3/static/sql-explain.html
#' @export
db_explain.CKANConnection <- function(con, sql, format = "text", ...) {
  format <- match.arg(format, c("text", "json", "yaml", "xml"))

  exsql <- build_sql("EXPLAIN ",
    if (!is.null(format)) build_sql("(FORMAT ", sql(format), ") "),
    sql)
  expl <- dbGetQuery(con, exsql)

  paste(expl[[1]], collapse = "\n")
}

#' @export
db_insert_into.CKANConnection <- function(con, table, values, ...) {
  .read_only("db_insert_into.CKANConnection")
}
