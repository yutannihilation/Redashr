#' Connection for 'Redash' Database
#'
#' @name connection
#' @export
#' @keywords internal
setClass("RedashConnection",
         contains = "DBIConnection",
         slots = list(
           base_url = "character",
           api_key = "character",
           data_source_id = "integer"
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
setMethod("dbConnect", "RedashDriver",
          function(drv,
                   base_url = "http://localhost",
                   api_key = "",
                   dsn = 1L,
                   ...) {
  if (is.numeric(dsn)) {
    data_source_id <- as.integer(dsn)
  } else {
    # TODO: normalize host
    data_sources <- get_data_sources(base_url, api_key)
    data_source <- data_sources[[dsn]]

    if (is.null(data_source)) {
      stop(glue::glue("No such data source: {dsn}"))
    }

    data_source_id <- data_source[["id"]]
  }

  new("RedashConnection",
      base_url = base_url,
      api_key  = api_key,
      data_source_id = data_source_id,
      ...)
})

#' @export
setMethod("dbDisconnect", "RedashConnection", function(conn, ...) {
  TRUE
})



