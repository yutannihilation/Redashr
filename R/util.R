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
