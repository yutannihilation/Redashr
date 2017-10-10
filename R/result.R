#' Result for 'Redash' 'MySQL' Database
#'
#' @keywords internal
#' @export
setClass("RedashMySQLResult",
         contains = "MySQLResult",
         slots = list(ptr = "externalptr")
)

#' @export
setMethod("dbSendQuery", "RedashMySQLConnection", function(conn, statement, ...) {
  new("RedashMySQLResult", ...)
})

#' @export
setMethod("dbClearResult", "RedashMySQLConnection", function(res, ...) {
  TRUE
})

#' @export
setMethod("dbFetch", "RedashMySQLResult", function(res, n = -1, ...) {
  TRUE
})

#' @export
setMethod("dbHasCompleted", "RedashMySQLResult", function(res, ...) {
  TRUE
})
