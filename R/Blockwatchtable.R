#' Retrieves Data from a Blockwatch Datatable endpoint
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/accountprofile#/apikey}
#'
#' @param table_code Datatable code on Blockwatch specified as a string.
#' @param paginate When set to TRUE, fetches up to 1,000,000 rows of data
#' @param ... Additional named values that are interpreted as Blockwatch API parameters.
#' @return Returns a data.frame.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.table('BITFINEX:TRADE/BTC_USD', paginate=TRUE)
#' }
#' @export
blockwatch.table <- function(table_code, paginate = FALSE, ...) {
  path <- paste0("tables/", table_code)
  params <- list(...)

  # when pagination is on, fetch at max limit
  if (isTRUE(paginate) && is.null(params$limit)) {
    params["limit"] <- blockwatch.api.max_limit()
  }

  # make request for first page of data
  json <- do.call(blockwatch.api, c(path = path, params))

  # check embedded error
  if (!is.null(json$error)) {
    stop(paste(jsonlite::toJSON(json$error, auto_unbox=TRUE, pretty=TRUE)), call. = FALSE)
  }

  df <- as.data.frame(json$data, stringsAsFactors = FALSE)
  cursor <- json$cursor

  # continue to make requests for data if paginate=TRUE and there is data
  while (isTRUE(paginate) && length(json$data) > 0) {
    params["cursor"] <- cursor
    json <- do.call(blockwatch.api, c(path = path, params))
    if (!is.null(json$error)) {
      stop(paste(jsonlite::toJSON(json$error, auto_unbox=TRUE, pretty=TRUE)), call. = FALSE)
    }
    df_page <- as.data.frame(json$data, stringsAsFactors = FALSE)

    df <- rbind(df, df_page)
    cursor <- json$cursor

    # only fetch a maximum of 1,000,000 rows
    if (blockwatch.table.max_rows() > 0 && nrow(df) >= blockwatch.table.max_rows() && !is.null(cursor)) {
      if (!getOption("blockwatch.quiet", FALSE)) {
        warning(paste("This call returns more data than R can process efficiently.",
                      "See https://blockwatch.cc/docs/r#usage-limits for details."), call. = FALSE)
      }
      break
    }
  }

  if (!isTRUE(paginate) && !is.null(cursor) && json$limit == json$count) {
    if (!getOption("blockwatch.quiet", FALSE)) {
      warning(paste("This call can return more data. Increase your limit or set paginate=TRUE.",
                    "See https://blockwatch.cc/docs/r#accessing-tables-with-r for details."), call. = FALSE)
    }
  }

  # if df is empty create an empty df with ncolumns set
  # or else we won't be able to set the column names
  ncols <- length(json$columns$code)
  if (nrow(df) <= 0 && ncols > 0) {
    df <- data.frame(matrix(ncol = ncols, nrow = 0))
  }

  # set column names
  names(df) <- json$columns$code

  # set column types
  column_types <- tolower(json$columns$type)
  for (i in 1:length(column_types)) {
    if (grepl("^float|^bigdecimal|^int|^uint", column_types[i])) {
      df[, i] <- as.numeric(df[, i])
    } else if (grepl("^datetime", column_types[i])) {
      df[, i] <- as.POSIXct(as.numeric(df[, i])/1000, origin = "1970-01-01", tz="UTC")
    } else if (grepl("^date", column_types[i])) {
      df[, i] <- as.Date(df[, i])
    } else if (grepl("^bool", column_types[i])) {
      df[, i] <- as.logical(as.numeric(df[, i]))
    } else {
      df[, i] <- as.character(df[, i])
    }
  }

  return(df)
}
