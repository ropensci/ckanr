.read_only <- function(fname) {
  stop(sprintf("(%s) This interface is read-only currently", fname))
}

## DBI Interface

setClass("CKANDriver", representation("DBIDriver"))

setMethod("dbUnloadDriver", "CKANDriver",
          def = function(drv, ...) invisible(NULL),
          valueClass = "logical"
          )

setMethod("dbGetInfo", "CKANDriver",
          def = function(dbObj, ...) {
            cat(sprintf("DBI Interface for CKAN\n"))
          }
          )

setMethod("summary", "CKANDriver",
          def = function(object, ...) dbGetInfo(object, ...)
          )

##
## Class: DBIConnection
##
setClass("CKANConnection", representation("DBIConnection", "url" = "character"))

setMethod("initialize", "CKANConnection", function(.Object, url, ...) {
  .Object@url <- url
  .Object
})

setMethod("dbConnect", "CKANDriver",
          def = function(drv, url, ...) new("CKANConnection", url),
          valueClass = "CKANConnection"
          )

## clone a connection
setMethod("dbConnect", "CKANConnection",
          def = function(drv, ...) drv,
          valueClass = "CKANConnection"
          )

setMethod("dbDisconnect", "CKANConnection",
          def = function(conn, ...) invisible(TRUE),
          valueClass = "logical"
          )

setClass("CKANResult", representation("DBIResult", value = "list", cache = "environment"))

setMethod("initialize", "CKANResult", function(.Object, value, ...) {
  .Object@value <- value
  .Object@cache <- new.env()
  .Object@cache$fetch <- 0L
  .Object
})

setMethod("dbSendQuery",
          signature(conn = "CKANConnection", statement = "character"),
          def = function(conn, statement,...) {
            retval <- ds_search_sql(as.character(statement), url = conn@url, as = "table")
            new("CKANResult", value = retval)
          },
          valueClass = "CKANResult"
          )


setMethod("dbGetQuery",
          signature(conn = "CKANConnection", statement = "character"),
          def = function(conn, statement, ...) {
            retval <- dbSendQuery(conn, statement, ...)
            retval@value$records
          }
          )

setMethod("dbGetException", "CKANConnection",
          def = function(conn, ...) {
              list()
          },
          valueClass = "list"
          )

setMethod("dbGetInfo", "CKANConnection",
          def = function(dbObj, ...) {
            cat(sprintf("url: %s\n", dbObj@url))
          }
          )

setMethod("dbListResults", "CKANConnection",
          def = function(conn, ...) dbGetInfo(conn, "rsId")[[1]]
          )

setMethod("summary", "CKANConnection",
          def = function(object, ...) dbGetInfo(object)
          )

## convenience methods
setMethod("dbListTables", "CKANConnection",
          def = function(conn, ...){
              stop("TODO: dbListTables")
          },
          valueClass = "character"
          )

setMethod("dbReadTable", signature(conn="CKANConnection", name="character"),
          def = function(conn, name, ...) {
            sql <- sprintf('SELECT * FROM "%s"', name)
            dbGetQuery(conn, sql)
          },
          valueClass = "data.frame"
          )

setMethod("dbWriteTable",
          signature(conn="CKANConnection", name="character", value="data.frame"),
          def = function(conn, name, value, ...){
              .read_only("dbWriteTable")
          },
          valueClass = "logical"
          )

setMethod("dbExistsTable",
          signature(conn="CKANConnection", name="character"),
          def = function(conn, name, ...){
            stop("TODO: dbExistsTable")
          },
          valueClass = "logical"
          )

setMethod("dbRemoveTable",
          signature(conn="CKANConnection", name="character"),
          def = function(conn, name, ...){
            .read_only("dbRemoveTable")
          },
          valueClass = "logical"
          )

## return field names (no metadata)
setMethod("dbListFields",
          signature(conn="CKANConnection", name="character"),
          def = function(conn, name, ...){
              stop("TODO: dbListFields")
          },
          valueClass = "character"
          )


setMethod("dbCallProc", "CKANConnection",
          def = function(conn, ...) {
            stop("TODO: dbCallProc")
          }
          )

setMethod("dbCommit", "CKANConnection",
          def = function(conn, ...) {
            stop("TODO: dbCommit")
          }
          )

setMethod("dbRollback", "CKANConnection",
          def = function(conn, ...) {
            stop("TODO: dbRollback")
          }
          )

setMethod("dbClearResult", "CKANResult",
          def = function(res, ...) {
            TRUE
          },
          valueClass = "logical"
          )

setMethod("fetch", signature(res="CKANResult", n="numeric"),
          def = function(res, n, ...){
            if (n < 1) {
              res@cache$fetch <- nrow(res@value$records)
              return(res@value$records)
            }
            if (res@cache$fetch + 1 > nrow(res@value$records)) stop("Empty CKANResult")
            end <- min(nrow(res@value$records), res@cache$fetch + n)
            .i <- seq(res@cache$fetch + 1, end, by = 1)
            retval <- res@value$records[.i,]
            res@cache$fetch <- end
          },
          valueClass = "data.frame"
          )

setMethod("fetch",
          signature(res="CKANResult", n="missing"),
          def = function(res, n, ...){
              res@value$records
          },
          valueClass = "data.frame"
          )

setMethod("dbGetInfo", "CKANResult",
          def = function(dbObj, ...) {
            dbObj@value[-1]
          },
          valueClass = "list"
          )

setMethod("dbGetStatement", "CKANResult",
          def = function(res, ...){
              dbGetInfo(res)$sql
          },
          valueClass = "character"
          )

setMethod("dbListFields",
          signature(conn="CKANResult", name="missing"),
          def = function(conn, name, ...){
              retval <- as.character(conn@value$fields$id)
              retval
          },
          valueClass = "character"
          )

setMethod("dbColumnInfo", "CKANResult",
          def = function(res, ...) dbListFields(res, ...),
          valueClass = "data.frame"
          )

setMethod("dbGetRowsAffected", "CKANResult",
          def = function(res, ...) stop("TODO: dbGetRowsAffected"),
          valueClass = "numeric"
          )

setMethod("dbGetRowCount", "CKANResult",
          def = function(res, ...) nrow(res@value$records),
          valueClass = "numeric"
          )

setMethod("dbHasCompleted", "CKANResult",
          def = function(res, ...) TRUE,
          valueClass = "logical"
          )

setMethod("dbGetException", "CKANResult",
          def = function(conn, ...){
              list()
          },
          valueClass = "list"    ## TODO: should be a DBIException?
          )

setMethod("summary", "CKANResult",
          def = function(object, ...) stop("TODO: summary.CKANResult")
          )

