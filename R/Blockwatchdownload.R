#' Downloads a zip with all data from a Blockwatch database
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' @param database_code Database code on Blockwatch specified as a string.
#' @param filename Filename (including path) of file to download.
#' @param ... Additional named values that are interpreted as Blockwatch API parameters. Please see \url{https://blockwatch.cc/docs/api} for a full list of parameters.
#' @return The filename of the downloaded file.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.download("BITFINEX:OHLCV/BTC_USD", "./BITFINEX_OHLVC_BTC_USD.zip")
#' }
#' @export
blockwatch.download <- function(database_code, filename, ...) {
  dirname <- dirname(filename)
  blockwatch.api.download_file(Blockwatch.download_url_path(database_code), filename = filename, ...)
}

Blockwatch.download_url_path <- function(database_code) {
  paste("databases", database_code, "download", sep = "/")
}
