#' Driver for 'Redash' 'MySQL' Database
#'
#' @name driver
#' @keywords internal
#' @export
setClass("RedashMySQLDriver", contains = "DBIDriver")

#' @export
#' @rdname driver
setMethod("dbUnloadDriver", "RedashMySQLDriver", function(drv, ...) {
  TRUE
})

setMethod("show", "RedashMySQLDriver", function(object) {
  cat("<RedashMySQLDriver>\n")
})

#' @export
RedashMySQL <- function() {
  new("RedashMySQLDriver")
}
