#' Connection for 'Redash' 'MySQL' Database
#'
#' @name connection
#' @export
#' @keywords internal
setClass("RedashMySQLConnection",
         contains = "MySQLConnection",
         slots = list(
           host = "character",
           username = "character",
           api_key = "character",
           ptr = "externalptr"
         )
)


#' @param drv An object created by `RedashMySQL`
#' @rdname connection
#' @export
#' @examples
#' \dontrun{
#' db <- dbConnect(RedashMySQL::RedashMySQL())
#' dbWriteTable(db, "mtcars", mtcars)
#' dbGetQuery(db, "SELECT * FROM mtcars WHERE cyl == 4")
#' }
setMethod("dbConnect", "RedashMySQLDriver", function(drv, ...) {

  new("RedashMySQLConnection", host = host, ...)
})
