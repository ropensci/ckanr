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
    cat("DBI Interface for CKAN\n")
  }
)

setMethod("summary", "CKANDriver",
  def = function(object, ...) dbGetInfo(object, ...)
)

##
## Class: DBIConnection
##
setClass("CKANConnection", representation(
  "DBIConnection", "url" = "character", "key" = "character"
))

setMethod("initialize", "CKANConnection", function(
  .Object, url, key = get_default_key(), ...
) {
  .Object@url <- url
  .Object@key <- key
  .Object
})

setMethod("dbConnect", "CKANDriver",
  def = function(drv, url, key = get_default_key(), ...) {
    new("CKANConnection", url = url, key = key)
  },
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

fieldMapping <- Vectorize(function(type) {
  switch(type,
    "bigint" = "integer",
    "bigserial" = "integer",
    "bytea" = "raw",
    "double precision" = "numeric",
    "integer" = "integer",
    "money" = "numeric",
    "real" = "numeric",
    "smallint" = "integer",
    "smallserial" = "integer",
    "serial" = "integer",
    {
      if (grepl("numeric", type)) "numeric" else "character"
    }
  )
})

setMethod("initialize", "CKANResult", function(.Object, value, ...) {
  if (is.null(value)) {
    stop("No result")
  }
  types <- fieldMapping(value$fields$type)
  if (!is.data.frame(value$records)) {
    args <- lapply(seq_len(nrow(value$fields)), function(i) {
      switch(types[i],
        "character" = character(0),
        "integer" = integer(0),
        "logical" = logical(0),
        "numeric" = numeric(0),
        stop("Unknown type")
      )
    })
    names(args) <- value$fields$id
    args[["stringsAsFactors"]] <- FALSE
    args[["check.names"]] <- FALSE
    value$records <- do.call(data.frame, args)
  } else {
    df <- value$records
    for (i in seq_len(nrow(value$fields))) {
      f <- switch(types[i],
        "character" = as.character,
        "integer" = as.integer,
        "logical" = as.logical,
        "numeric" = as.numeric,
        stop("Unknown type")
      )
      df[[value$fields$id[i]]] <- f(df[[value$fields$id[i]]])
    }
    value$records <- df
  }
  .Object@value <- value
  .Object@cache <- new.env()
  .Object@cache$fetch <- 0L
  .Object
})

setMethod("dbSendQuery",
  signature(conn = "CKANConnection", statement = "character"),
  def = function(conn, statement, ...) {
    retval <- ds_search_sql(
      as.character(statement), url = conn@url, key = conn@key, as = "table"
    )
    new("CKANResult", value = retval)
  },
  valueClass = "CKANResult"
)

setMethod("dbFetch",
  signature(res = "CKANResult", n = "numeric"),
  def = function(res, n = -1, ...) fetch(res, n),
  valueClass = "data.frame"
)

setMethod("dbFetch",
  signature(res = "CKANResult", n = "missing"),
  def = function(res, n, ...) fetch(res, -1),
  valueClass = "data.frame"
)


setMethod("dbGetQuery",
  signature(conn = "CKANConnection", statement = "character"),
  def = function(conn, statement, ...) {
    retval <- dbSendQuery(conn, statement, ...)
    on.exit(dbClearResult(retval))
    dbFetch(retval)
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
    list(url = dbObj@url)
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
  def = function(conn, ...) {
    dots <- list(...)
    limit <- if (is.null(dots$limit)) NULL else dots$limit
    if (is.null(limit)) {
       out1 <- ds_search(
         "_table_metadata", url = conn@url, key = conn@key,
         as = "table", limit = 1
       )
       out <- ds_search(
         "_table_metadata", url = conn@url, key = conn@key,
         as = "table", limit = out1$total
       )
    } else {
      out <- ds_search(
        "_table_metadata", url = conn@url, key = conn@key,
        as = "table", limit = limit
      )
    }
    out$records$name
  },
  valueClass = "character"
)

setMethod("dbReadTable", signature(conn = "CKANConnection", name = "character"),
  def = function(conn, name, ...) {
    sql <- sprintf('SELECT * FROM "%s"', name)
    dbGetQuery(conn, sql)
  },
  valueClass = "data.frame"
)

setMethod("dbWriteTable",
  signature(conn = "CKANConnection", name = "character", value = "data.frame"),
  def = function(conn, name, value, ...) {
    .read_only("dbWriteTable")
  },
  valueClass = "logical"
)

setMethod("dbCreateTable", "CKANConnection",
  def = function(conn, name, fields, ...) {
    .read_only("dbCreateTable")
  },
  valueClass = "logical"
)

setMethod("dbExistsTable",
  signature(conn = "CKANConnection", name = "character"),
  def = function(conn, name, ...) {
    name %in% dbListTables(conn, ...)
  },
  valueClass = "logical"
)

setMethod("dbRemoveTable",
  signature(conn = "CKANConnection", name = "character"),
  def = function(conn, name, ...) {
    .read_only("dbRemoveTable")
  },
  valueClass = "logical"
)

## return field names (no metadata)
setMethod("dbListFields",
  signature(conn = "CKANConnection", name = "character"),
  def = function(conn, name, ...) {
    identifier <- as.character(DBI::dbQuoteIdentifier(conn, name))
    sql <- sprintf("SELECT * FROM %s LIMIT 0", identifier)
    result <- ds_search_sql(
      sql, url = conn@url, key = conn@key, as = "table", ...
    )
    as.character(result$fields$id)
  },
  valueClass = "character"
)


setMethod("dbCallProc", "CKANConnection",
  def = function(conn, ...) {
    stop("TODO: dbCallProc")
  }
)

setMethod("dbBegin", "CKANConnection",
  def = function(conn, ...) .read_only("dbBegin"),
  valueClass = "logical"
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
    res@cache$fetch <- nrow(res@value$records)
    TRUE
  },
  valueClass = "logical"
)

setMethod("fetch", signature(res = "CKANResult", n = "numeric"),
  def = function(res, n, ...) {
    if (n == 0) {
      res@cache$fetch <- nrow(res@value$records)
      return(res@value$records)
    }
    if (n < 0) {
      n <- nrow(res@value$records) - res@cache$fetch
    }
    end <- min(nrow(res@value$records), res@cache$fetch + n)
    if (res@cache$fetch + 1 <= end) {
      .i <- seq(res@cache$fetch + 1, end, by = 1)
    } else {
      .i <- integer(0)
    }
    retval <- res@value$records[.i, , drop = FALSE]
    res@cache$fetch <- end
    retval
  },
  valueClass = "data.frame"
)

setMethod("fetch",
  signature(res = "CKANResult", n = "missing"),
  def = function(res, n, ...) {
    res@value$records
  },
  valueClass = "data.frame"
)

setMethod("dbGetInfo", "CKANResult",
  def = function(dbObj, ...) {
    dbObj@value
  },
  valueClass = "list"
)

setMethod("dbGetStatement", "CKANResult",
  def = function(res, ...) {
    dbGetInfo(res)$sql
  },
  valueClass = "character"
)

setMethod("dbListFields",
  signature(conn = "CKANResult", name = "missing"),
  def = function(conn, name, ...) {
    retval <- as.character(conn@value$fields$id)
    retval
  },
  valueClass = "character"
)

setMethod("dbColumnInfo", "CKANResult",
  def = function(res, ...) {
    fields <- res@value$fields
    data.frame(
      name = fields$id,
      type = fields$type,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  },
  valueClass = "data.frame"
)

setMethod("dbGetRowsAffected", "CKANResult",
  def = function(res, ...) nrow(res@value$records),
  valueClass = "numeric"
)

setMethod("dbGetRowCount", "CKANResult",
  def = function(res, ...) nrow(res@value$records),
  valueClass = "numeric"
)

setMethod("dbHasCompleted", "CKANResult",
  def = function(res, ...) res@cache$fetch >= nrow(res@value$records),
  valueClass = "logical"
)

setMethod("dbGetException", "CKANResult",
  def = function(conn, ...) {
    list()
  },
  valueClass = "list" ## TODO: should be a DBIException?
)

setMethod("dbBind", "CKANResult",
  def = function(res, params, ...) {
    stop(
      "CKAN DataStore SQL does not support parameter binding",
      call. = FALSE
    )
  }
)

setMethod("summary", "CKANResult",
  def = function(object, ...) stop("TODO: summary.CKANResult")
)
