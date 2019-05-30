#' Query or set Blockwatch API key
#' @param api_key Optionally passed parameter to set Blockwatch \code{api_key}.
#' @return Returns invisibly the currently set \code{api_key}.
#' @examples \dontrun{
#' blockwatch.api_key('foobar')
#' }
#' @export
blockwatch.api_key <- function(api_key) {
  if (!missing(api_key)) {
    options(blockwatch.api_key = api_key)
  }
  invisible(getOption("blockwatch.api_key"))
}

blockwatch.api_version <- function(api_version) {
  if (!missing(api_version)) {
    options(blockwatch.api_version = api_version)
  }
  invisible(getOption("blockwatch.api_version"))
}

#' Query or set Blockwatch API base url
#' @param base_url Optionally passed parameter to set Blockwatch \code{base_url}.
#' @return Returns invisibly the currently set \code{base_url}.
#' @examples \dontrun{
#' blockwatch.base_url('https://data.blockwatch.cc/v1')
#' }
#' @export
blockwatch.base_url <- function(base_url) {
  if (!missing(base_url)) {
    options(blockwatch.base_url = base_url)
  }
  invisible(getOption("blockwatch.base_url", blockwatch.default_url()))
}

blockwatch.default_url <- function() {
  return("https://data.blockwatch.cc/v1")
}


blockwatch.table.max_rows <- function() {
  if (blockwatch.base_url() == blockwatch.default_url()) {
    return(1000000)
  }
  return (0)
}

blockwatch.api.max_limit <- function() {
  return(50000)
}

#' Disable or enable warning messages
#' @param enable True will disable warnings.
#' @examples \dontrun{
#' blockwatch.quiet()
#' }
#' @export
blockwatch.quiet <- function(enable = TRUE) {
  options(blockwatch.quiet = enable)
}
