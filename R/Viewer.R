# 'Redash' Connection for 'RStudio'


on_connection_opened <- function(conn, connectCall) {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionOpened(
      type = "Redash",
      displayName = glue::glue("Redash: {conn@base_url}"),
      host = conn@base_url,
      icon = NULL,
      connectCode = connectCall,
      disconnect = function() {
        redash_disconnect(conn)
      },
      listObjectTypes =
    )
  }
}
