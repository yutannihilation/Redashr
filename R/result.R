#' Result for 'Redash' Database
#'
#' @keywords internal
#' @export
setClass("RedashResult",
         contains = "DBIResult",
         slots = list(ptr = "externalptr")
)

#' @export
setMethod("dbSendQuery", "RedashConnection", function(conn, statement, ...) {
  new("RedashResult", ...)
})

#' @export
setMethod("dbClearResult", "RedashConnection", function(res, ...) {
  TRUE
})

#' @export
setMethod("dbFetch", "RedashResult", function(res, n = -1, ...) {
  TRUE
})

#' @export
setMethod("dbDataType", "RedashConnection", function(dbObj, obj, ...) {
  TRUE
})

#' @export
setMethod("dbHasCompleted", "RedashResult", function(res, ...) {
  TRUE
})
