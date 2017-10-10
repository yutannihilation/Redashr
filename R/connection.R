#' Connection for 'Redash' Database
#'
#' @name connection
#' @export
#' @keywords internal
setClass("RedashConnection",
         contains = "DBIConnection",
         slots = list(
           host = "character",
           username = "character",
           api_key = "character",
           ptr = "externalptr"
         )
)


#' @param drv An object created by `Redash`
#' @rdname connection
#' @export
#' @examples
#' \dontrun{
#' db <- dbConnect(Redashr::Redash())
#' dbWriteTable(db, "mtcars", mtcars)
#' dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == 4")
#' }
setMethod("dbConnect", "RedashDriver", function(drv, ...) {
  new("RedashConnection", ...)
})

#' @export
setMethod("dbDisconnect", "RedashConnection", function(conn, ...) {
  TRUE
})
