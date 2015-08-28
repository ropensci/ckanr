#'@export
src_ckan <- function(url) {
  library(dplyr)
  drv <- new("CKANDriver")
  con <- dbConnect(drv, url = url)
  info <- dbGetInfo(con)
  src_sql("ckan", con, info = info)
}

#'@export
tbl.src_ckan <- function(src, from, ...) {
  tbl_sql("ckan", src = src, from = from, ...)
}

#'@export
src_desc.src_ckan <- function(x) {
  info <- x$info
  paste0("ckan url: %s", src$con@url)
}

#' @export
src_translate_env.src_ckan <- dplyr:::src_translate_env.src_postgres

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
