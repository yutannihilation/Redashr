# Utils

redash_request <- function(verb, url, api_key, ..., verbose = FALSE) {
  res <- httr::VERB(
    verb = verb,
    url  = url,
    config = httr::add_headers(Authorization = glue::glue("Key {api_key}")),
    ...
  )

  httr::stop_for_status(res)

  if (verbose) {
    httr::content(res)
  } else {
    suppressMessages(httr::content(res))
  }
}

get_data_sources <- function(base_url, api_key, ..., verbose = FALSE) {
  url <- glue::glue("{base_url}/api/data_sources")
  result <- redash_request("GET", url, api_key, ..., verbose = verbose)

  # result contains NULL, which makes bind_rows() to fail
  setNames(result, purrr::map_chr(result, "name"))
}

post_query <- function(base_url, api_key, query, query_id, data_source_id, ..., verbose = FALSE) {
  url <- glue::glue("{base_url}/api/query_results")

  redash_request(
    "POST", url, api_key,
    body = list(
      query = query,
      query_id = query_id,
      data_source_id = data_source_id
    ),
    encode = "json",
    ...,
    verbose = verbose
  )
}

IGNORE_ERRORS <- c(
  "Query completed but it returned no data."
)

get_job_status <- function(base_url, api_key, job_id, ..., verbose = FALSE) {
  url <- glue::glue("{base_url}/api/jobs/{job_id}")
  result <- redash_request("GET", url, api_key, ...)

  if (result$job$status == 4L) {
    if (result$job$error %in% IGNORE_ERRORS) {
      # treat the job as success
      result$job$status <- 3L
      result$job$no_result <- TRUE
    } else {
      stop(glue::glue("Query failed: {result$job$error}", call. = FALSE))
    }
  }

  result$job
}

get_result <- function(base_url, api_key, query_id, query_result_id, ..., verbose = FALSE) {
  url <- glue::glue("{base_url}/api/queries/{query_id}/results/{query_result_id}.csv")
  redash_request("GET", url, api_key, ..., verbose = verbose)
}


#' @export
get_supported_data_sources <- function(...) UseMethod("get_supported_data_sources")

#' @export
get_supported_data_sources.RedashConnection <- function(conn, ..., verbose = FALSE) {
  get_supported_data_sources(conn@base_url, conn@api_key, ..., verbose = verbose)
}

#' @export
get_supported_data_sources.default <- function(base_url, api_key, ..., verbose = FALSE) {
  url <- glue::glue("{base_url}/api/data_sources/types")
  res <- redash_request("GET", url, api_key, ..., verbose = verbose)
  data.frame(
    name = vapply(res, getElement, name = "name", FUN.VALUE = character(1L)),
    type = vapply(res, getElement, name = "type", FUN.VALUE = character(1L)),
    stringsAsFactors = FALSE
  )
}

`%||%` <- function (x, y) if (is.null(x)) y else x
