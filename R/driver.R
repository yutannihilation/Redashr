#' Driver for 'Redash' Database
#'
#' @name driver
#' @keywords internal
#' @export
setClass("RedashDriver", contains = "DBIDriver")

#' @export
#' @rdname driver
setMethod("dbUnloadDriver", "RedashDriver", function(drv, ...) {
  TRUE
})

setMethod("show", "RedashDriver", function(object) {
  cat(glue::glue("<RedashDriver>\n"))
})

#' @export
Redash <- function() {
  new("RedashDriver")
}

#' @export
setMethod("dbGetInfo", "RedashDriver", function(dbObj) {
  list(driver.version = NULL, client.version = NULL,
       backend_driver = dbObj@backend_driver)
})
