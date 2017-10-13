#' Result for 'Redash' Database
#'
#' @keywords internal
#' @export
setClass("RedashResult",
         contains = "DBIResult",
         slots = list(
           query = "character",
           query_id = "integer",
           no_result = "logical",
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
    no_result <- FALSE

    # Wait until the query execution finish
    if (is.null(query_result_id)) {
      job_id <- result$job$id

      if (is.null(job_id)) {
        stop("No result or job ID returned!")
      }

      while (TRUE) {
        message(glue::glue("Fetching the result of job {job_id}...\n"))

        job <- get_job_status(conn@base_url, conn@api_key, job_id)

        # 3: completed, 4: error
        if (job$status == 3L) {
          query_result_id <- as.character(job$query_result_id)
          no_result <- job$no_result %||% FALSE
          break
        }

        Sys.sleep(3L)
      }
    }

    new("RedashResult",
        query = statement,
        query_id = query_id,
        no_result = no_result,
        query_result_id = as.character(query_result_id),
        conn = conn)
})

#' @export
setMethod("dbClearResult", "RedashConnection", function(res, ...) {
  invisible(TRUE)
})

#' @export
setMethod("dbFetch", "RedashResult", function(res, n = -1, ...) {
  if (res@no_result) {
    return(data.frame())
  }
  get_result(res@conn@base_url, res@conn@api_key, res@query_id, res@query_result_id)
})

#' @export
setMethod("dbDataType", "RedashConnection", function(dbObj, obj, ...) {
  dbDataType(new(dbObj@backend_connection_class), obj, ...)
})

#' @export
setMethod("dbDataType", "RedashDriver", function(dbObj, obj, ...) {
  # TODO: Driver doesn't know the backend...
  dbDataType(DBI::ANSI(), obj, ...)
})

#' @export
setMethod("dbHasCompleted", "RedashResult", function(res, ...) {
  TRUE
})

#' @export
setMethod("dbClearResult", "RedashResult", function(res, ...) {
  res@conn@ref$result <- NULL
  TRUE
})
