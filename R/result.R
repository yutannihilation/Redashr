#' Result for 'Redash' Database
#'
#' @keywords internal
#' @export
setClass("RedashResult",
         contains = "DBIResult",
         slots = list(
           query = "character",
           query_id = "integer",
           query_result_id = "character",
           conn = "RedashConnection"
         )
)

#' @export
setMethod("dbSendQuery", "RedashConnection",
  function(conn, statement, ...) {
    if (!is.null(conn@ref$result)) {
      warning("Closing open result set, pending rows", call. = FALSE)
      dbClearResult(conn@ref$result)
      stopifnot(is.null(conn@ref$result))
    }

    query_id <- query_id(conn)
    result <- post_query(base_url = conn@base_url,
                         api_key  = conn@api_key,
                         query    = statement,
                         query_id = query_id,
                         data_source_id = conn@data_source_id)

    query_result_id <- result$query_result$id

    # Wait until the query execution finish
    if (is.null(query_result_id)) {
      job_id <- result$job$id

      if (is.null(job_id)) {
        stop("No result or job ID returned!")
      }

      while (TRUE) {
        query_result_id_raw <- try_get_query_result_id(conn@base_url, conn@api_key, job_id)

        if (!is.null(query_result_id)) break

        Sys.sleep(3L)
      }
    }

    new("RedashResult",
        query = statement,
        query_id = query_id,
        query_result_id = as.character(query_result_id),
        conn = conn)
})

#' @export
setMethod("dbClearResult", "RedashConnection", function(res, ...) {
  invisible(TRUE)
})

#' @export
setMethod("dbFetch", "RedashResult", function(res, n = -1, ...) {
  get_result(res@conn@base_url, res@conn@api_key, res@query_id, res@query_result_id)
})

#' @export
setMethod("dbDataType", "RedashConnection", function(dbObj, obj, ...) {
  dbDataType(RPostgreSQL::PostgreSQL(), obj, ...)
})

#' @export
setMethod("dbDataType", "RedashDriver", function(dbObj, obj, ...) {
  dbDataType(RPostgreSQL::PostgreSQL(), obj, ...)
})


#' @export
setMethod("dbDataType", "RedashConnection", function(dbObj, obj, ...) {
  dbDataType(RMariaDB::MariaDB(), obj, ...)
})

#' @export
setMethod("dbHasCompleted", "RedashResult", function(res, ...) {
  TRUE
})
