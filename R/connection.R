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
           data_source_id = "integer",
           data_source_driver = "DBIDriver",
           ref = "environment"
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
                   data_source_name = "",
                   ...) {

  # TODO: normalize host
  data_sources <- get_data_sources(base_url, api_key)
  data_source <- data_sources[[data_source_name]]

  if (is.null(data_source)) {
    stop(glue::glue("No such data source: {data_source_name}"))
  }

  data_source_id <- data_source$id

  # TODO: support more backends
  data_source_driver <- switch(
    data_source$type,
    "pg" = RPostgreSQL::PostgreSQL(),
    RPostgreSQL::PostgreSQL()
  )

  ref_env <- new.env(parent = emptyenv())
  ref_env$query_id <- 0L

  new("RedashConnection",
      base_url = base_url,
      api_key  = api_key,
      data_source_id = data_source_id,
      data_source_driver = data_source_driver,
      ref = ref_env,
      ...)
})

setGeneric("query_id", function(x) standardGeneric("query_id"))

setMethod("query_id", "RedashConnection", function(x) {
  x@ref$query_id <- x@ref$query_id + 1L
  x@ref$query_id
})

#' @export
setMethod("dbDisconnect", "RedashConnection", function(conn, ...) {
  invisible(TRUE)
})



