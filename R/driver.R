#' Driver for 'Redash' Database
#'
#' @name driver
#' @keywords internal
#' @export
setClass("RedashDriver", contains = "DBIDriver",
         slots = list(backend_driver = "DBIDriver"))

#' @export
#' @rdname driver
setMethod("dbUnloadDriver", "RedashDriver", function(drv, ...) {
  TRUE
})

setMethod("show", "RedashDriver", function(object) {
  backend <- as.character(class(d@backend_driver))
  cat(glue::glue("<RedashDriver (backend: {backend})>\n"))
})

#' @export
Redash <- function(backend_driver = RPostgreSQL::PostgreSQL()) {
  new("RedashDriver", backend_driver = backend_driver)
}

#' @export
setMethod("dbGetInfo", "RedashDriver", function(dbObj) {
  list(driver.version = NULL, client.version = NULL,
       backend_driver = dbObj@backend_driver)
})
