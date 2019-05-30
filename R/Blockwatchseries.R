#' Retrieves Data from a Blockwatch Time Series endpoint
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https:/blockwatch.cc/account/profile#apikey}.
#'
#' @param code Dataset code on Blockwatch specified as a string or an array of strings.
#' @param datatype Type of data returned specified as string. Can be 'raw', 'ts', 'zoo', 'xts' or 'timeSeries'.
#' @param transform Apply Blockwatch API data transformations.
#' @param collapse Collapse frequency of Data.
#' @param order Select if data is given to R in ascending or descending formats. Helpful for the rows parameter.
#' @param force_irregular When set to TRUE, forces the index of the Data to be of date format yyyy-mm-dd
#' @param ... Additional named values that are interpreted as Blockwatch API parameters. Please see \url{https:/blockwatch.cc/docs/api#database-metadata-api} for a full list of parameters.
#' @return Depending on the type the class is either data.frame, time series, xts, zoo or timeSeries.
#' @references This R package uses the Blockwatch API. For more information go to \url{https:/blockwatch.cc/docs/api}. For more help on the package itself go to \url{https:/blockwatch.cc/docs/r}.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' data = blockwatch.series("BITFINEX:OHLCV/BTC_USD", start_date="2018-01-01", datatype="ts")
#' plot(data[,1])
#' }
#' @importFrom zoo zoo
#' @importFrom zoo as.zooreg
#' @importFrom zoo as.yearmon
#' @importFrom zoo as.yearqtr
#' @importFrom xts xts
#' @importFrom xts as.xts
#' @export
blockwatch.series <- function(code, datatype = c("raw", "ts", "zoo", "xts", "timeSeries"),
                   transform = c("", "diff", "rdiff", "normalize", "cumul", "rdiff_from"),
                   collapse = c("", "1m", "5m", "15m", "30m", "1h", "3h", "6h", "12h", "1d", "1w", "1M", "3M", "1y", "daily", "weekly", "monthly", "quarterly", "annual"),
                   order = c("asc", "desc"), force_irregular = FALSE, ...) {
  params <- list(...)
  ## Check params
  datatype <- match.arg(datatype)
  if (!is.null(transform) && transform != "") {
    params$transform <- match.arg(transform)
  }
  if (!is.null(collapse) && collapse != "") {
    params$collapse <- match.arg(collapse)
  }
  if (!is.null(order) && order != "") {
    params$order <- match.arg(order)
  }

  ## validate date format if supplied
  if (!is.null(params$start_date)) {
    as.Date(params$start_date)
  }

  if (!is.null(params$end_date)) {
    as.Date(params$end_date)
  }

  if (datatype == "timeSeries" && system.file(package = datatype) == "") {
    stop("Package ", datatype, " needed to use this datatype", call. = FALSE)
  }

  ## Helper functions
  frequency2integer <- function(freq) {
    if (is.null(freq) || is.na(freq)) {
      return(365)
    } else {
      switch(freq,
           # "1m", "5m", "15m", "30m", "1h", "3h", "6h", "12h",
           # cannot express as integers with seasonality = 1 year!
           # "1d", "1w", "1M", "3M", "1y"
           "daily"     = 365,
           "1d"        = 365,
           "weekly"    = 52,
           "1w"        = 52,
           "monthly"   = 12,
           "1M"        = 12,
           "quarterly" = 4,
           "3M"        = 4,
           "yearly"    = 1,
           "1y"        = 1,
           1)
    }
  }

  as.year <- function(x) {
    floor(as.numeric(as.yearmon(x)))
  }

  check.code <- function(code) {
    if (!all(gsub("[^A-Z0-9_.:/\\-]", "", code) == code)) {
      stop("Dataset codes are comprised of capital letters, numbers, dashes and underscores only.")
    }

    codearray <- strsplit(code, "/")
    if (length(codearray[[1]]) != 2) {
      stop("Invalid dataset code! Must be of form <database_code>/<dataset_code>")
    }
  }

  freq <- frequency2integer(params$collapse)

  ## Download and parse data
  errors <- list()
  if (length(code) == 1) {
    # fetch a single series
    check.code(code)
    data <- blockwatch.series.get(code, params)
  } else {
    # fetch multiple series and merge
    data <- NULL
    for (c in code) {
      tmp.params <- params
      check.code(c)

      merge_data <- tryCatch(blockwatch.series.get(c, tmp.params), error = function(e) {
        d <- data.frame(Date = character(0), ERROR = numeric(0))
        attr(d, "errors") <- e
        return(d)
      })

      suppressWarnings(errors[c] <- attr(merge_data, "errors"))

      for (i in 2:length(names(merge_data))) {
        names(merge_data)[i] <- paste(sub("/", ".", c), names(merge_data)[i], sep = " - ")
      }

      if (is.null(data)) {
        data <- merge_data
      } else {
        data <- merge(data, merge_data, by = 1, all = TRUE)
      }
    }
  }

  ## Returning raw data
  if (datatype == "raw") {
    data_out <- data
  } else {
    # Deal with regularly spaced time series first
    if (freq %in% c(1, 4, 12) && !force_irregular) {
      # Build regular zoo with correct frequency
      if (freq == 1) {
        data_out <- zoo::zoo(data[, -1], frequency = freq, as.year(data[, 1]))
      } else if (freq == 4) {
        data_out <- zoo::zoo(
          data[, -1], frequency = freq, as.yearqtr(data[, 1])
        )
      } else if (freq == 12) {
        data_out <- zoo::zoo(
          data[, -1], frequency = freq, as.yearmon(data[, 1])
        )
      }

      # Convert to type
      if (datatype == "ts") {
        data_out <- stats::as.ts(data_out)
      } else if (datatype == "zoo") {
        data_out <- zoo::as.zooreg(data_out)
      } else if (datatype == "xts") {
        data_out <- if (freq == 1) {
          xts::xts(data[, -1], frequency = 1, order.by = data[, 1])
        } else  {
          xts::as.xts(data_out)
        }
        if (freq != stats::frequency(data_out)) {
          warning("xts has a non-standard meaning for 'frequency'.")
        }
      } else if (datatype == "timeSeries") {
        data_out <- timeSeries::timeSeries(
          data = data[, -1],
          charvec = data[, 1]
        )
      }

    } else if (datatype == "zoo" || datatype == "ts") {
      # Time series is not regularly spaced
      if (datatype == "ts") {
        warning("Type 'ts' does not support frequency ", freq, ". Returning zoo.")
      }
      data_out <- zoo::zoo(data[, -1], order.by = data[, 1])
    } else if (datatype == "xts") {
      data_out <- xts::xts(data[, -1], order.by = data[, 1])
    } else if (datatype == "timeSeries") {
      data_out <- timeSeries::timeSeries(data = data[, -1], charvec = data[, 1])
    }
  }

  if (length(errors) > 0) {
    attr(data_out, "errors") <- errors
  }

  return(data_out)
}

#' Internal method to retrieve data from a Blockwatch time series endpoint
#'
#' @param code Dataset code on Blockwatch specified as a string.
#' @param params A list of parameters to be passed to the Blockwatch API. Please see \url{https:/blockwatch.cc/docs/api#retrieve-data-and-metadata} for a full list of parameters.
#' @return Returns a data.frame of the requested data
#' @seealso \code{\link{blockwatch.api_key}}, \code{\link{blockwatch.table}}
#' @examples \dontrun{
#' data = blockwatch.series.get("TRADE/BITFINEX_BTC_USD", list(limit=5))
#' plot(data[,1])
#' }
blockwatch.series.get <- function(code, params) {
  path <- paste0("series/", code)
  json <- do.call(blockwatch.api, c(path = path, params))

  if (length(json$data) == 0) {
    # if df is empty create an empty df with ncolumns set
    # or else we won't be able to set the column names
    ncols <- length(json$columns)
    if (ncols > 0) {
      df <- data.frame(matrix(ncol = ncols, nrow = 0))
      warning("empty server response")
    } else {
      stop("Error: empty server response", )
    }
  } else {
    df <- as.data.frame(json$data, stringsAsFactors = FALSE)
  }
  names(df) <- json$columns$code

  ## set columns types (transform values to numeric, date or string)
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

  # keep extra result parameters as attributes
  attr(df, "transform") <- json$transform
  attr(df, "collapse") <- json$collapse
  attr(df, "order") <- json$order
  attr(df, "start_date") <- as.POSIXct(json$start_date/1000, origin = "1970-01-01", tz="UTC")
  attr(df, "end_date") <- as.POSIXct(json$end_date/1000, origin = "1970-01-01", tz="UTC")
  attr(df, "limit") <- json$limit
  attr(df, "count") <- json$count

  return(df)
}
