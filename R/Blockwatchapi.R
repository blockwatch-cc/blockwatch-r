#' Internal method to execute Blockwatch API calls
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' @param path Path to api resource.
#' @param http Type of http request sent.
#' @param postdata A character or raw vector that is sent in a body.
#' @param ... Named values that are interpretted as Blockwatch API parameters. Please see \url{https://blockwatch.cc/docs/api}.
#' @return Blockwatch API response.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatchdata = blockwatch.api(path="series/BITFINEX:OHLCV/BTC_USD", http="GET")
#' plot(blockwatchdata[,1])
#' }
#' @importFrom httr VERB
#' @importFrom jsonlite fromJSON
blockwatch.api <- function(path, http = c("GET"), postdata = NULL, ...) {
  http <- match.arg(http)
  path <- paste(path, ".json", sep="")
  request <- blockwatch.api.build_request(path, ...)
  response <- httr::VERB(http, request$request_url,
                         config = do.call(httr::add_headers, request$headers),
                         body = postdata, query = request$params)

  blockwatch.api.handle_errors(response)
  text_response <- httr::content(response, as = "text")

  json_response <- tryCatch(jsonlite::fromJSON(text_response, simplifyVector = TRUE), error = function(e) {
      stop(e, " Failed to parse response: ", text_response)
    })
  json_response
}

blockwatch.api.download_file <- function(path, filename, ...) {
  request <- blockwatch.api.build_request(path, ...)
  response <- httr::GET(request$request_url,
                        config = do.call(httr::add_headers, request$headers),
                        query = request$params,
                        httr::write_disk(filename, overwrite = TRUE),
                        httr::progress())
  blockwatch.api.handle_errors(response)
  cat("Saved to file:", response$content)
}

blockwatch.api.build_request <- function(path, ...) {
  params <- list(...)
  # ensure vectors get converted into v1 api supported query params
  # e.g., columns=c('time', 'price') -> list('columns[]'=time,'columns[]'=price)
  params <- blockwatch.api.build_query_params(params)
  # ensure Dates convert to characters or else curl will convert the Dates to timestamp
  params <- blockwatch.api.convert_dates_to_character(params)

  request_url <- paste(blockwatch.base_url(), path, sep = "/")
  accept_value <- "application/json"
  if (!is.null(blockwatch.api_version())) {
    accept_value <- paste0("application/json, application/vnd.blockwatch.cc+json;version=", blockwatch.api_version())
  }

  blockwatch_version <- as.character(utils::packageVersion("blockwatch"))
  headers <- list(Accept = accept_value, `Request-Source` = "R", `Request-Source-Version` = blockwatch_version)

  if (!is.null(blockwatch.api_key())) {
    headers <- c(headers, list(`X-Api-Key` = blockwatch.api_key()))
  }

  # query param api_key takes precedence
  if (!is.null(params$api_key)) {
    headers <- c(headers, list(`X-Api-Key` = params$api_key))
    params$api_key <- NULL
  }

  list(request_url = request_url, headers = headers, params = params)
}

blockwatch.api.handle_errors <- function(response) {
  if (!(httr::status_code(response) >= 200 && httr::status_code(response) < 300)) {
    stop(httr::content(response, as = "text"), call. = FALSE)
  }
}

blockwatch.api.convert_dates_to_character <- function(params) {
  convert_date_to_character <- function(param) {
    if (class(param) == "Date") {
      param <- as.character(param)
    }
    param
  }
  lapply(params, convert_date_to_character)
}

blockwatch.api.build_query_params <- function(params) {
  if (length(params) <= 0) {
    return(params)
  }
  mod_params <- list()
  for(i in 1:length(params)) {
    # keep the params the same if not a vector
    converted_params <- params[i]

    # check val to see if vector
    # if so, convert
    if (length(params[[i]]) > 1) {
      converted_params <- blockwatch.api.convert_vector_params(names(params[i]), params[[i]])
    }
    mod_params <- c(mod_params, converted_params)
  }
  return(mod_params)
}

blockwatch.api.convert_vector_params <- function(name, vector_values) {
  mod_query_name <- paste0(name, "[]")
  mod_query_list <- list()

  for(val in vector_values) {
    l <- list()
    l[[mod_query_name]] <- val
    mod_query_list <- c(mod_query_list, l)
  }
  return(mod_query_list)
}
