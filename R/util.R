# Utils

redash_request <- function(verb, url, api_key, ...) {
  res <- httr::VERB(
    verb = verb,
    url  = url,
    config = httr::add_headers(Authorization = glue::glue("Key {api_key}")),
    ...
  )

  httr::stop_for_status(res)

  httr::content(res)
}

get_data_sources <- function(base_url, api_key, ...) {
  url <- glue::glue("{base_url}/api/data_sources")
  result <- redash_request("GET", url, api_key, ...)

  # result contains NULL, which makes bind_rows() to fail
  setNames(result, purrr::map_chr(result, "name"))
}

post_query <- function(base_url, api_key, query, query_id, data_source_id, ...) {
  url <- glue::glue("{base_url}/api/query_results")

  redash_request(
    "POST", url, api_key,
    body = list(
      query = query,
      query_id = query_id,
      data_source_id = data_source_id
    ),
    encode = "json",
    ...
  )
}

get_job_status <- function(base_url, api_key, job_id, ...) {
  url <- glue::glue("{base_url}/api/jobs/{job_id}")
  result <- redash_request("GET", url, api_key, ...)

  job_error <- result$job$error
  if (result$job$state != 4L && !identical(job_error, "")) {
    stop(glue::glue("Query failed: {job_error}", call. = FALSE))
  }

  result$job
}

get_result <- function(base_url, api_key, query_id, query_result_id, ...) {
  url <- glue::glue("{base_url}/api/queries/{query_id}/results/{query_result_id}.csv")
  redash_request("GET", url, api_key, ...)
}
