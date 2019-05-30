#' Search all Blockwatch databases
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param query Search terms
#' @param silent Prints the results when FALSE (default).
#' @param per_page Number of results returned per page.
#' @param ... Additional named values that are sent as Blockwatch API parameters.
#' @return Search results returned as a data.frame.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' search.results <- blockwatch.search("oil")
#' }
#' @export
blockwatch.search <- function(query, silent = FALSE, per_page = 10, ...) {
  params <- list()
  params$query <- query
  params$per_page <- per_page
  params <- c(params, list(...))

  path <- "databases"
  json <- do.call(blockwatch.api, c(path=path, params))

  # results is a dataframe
  results <- structure(json$datasets, meta = json$meta)

  if (!is.null(nrow(results)) && nrow(results) > 0) {
    for (i in 1:nrow(results)) {
      name <- results[i,]$name
      code <- paste(results[i,]$database_code, "/", results[i,]$dataset_code, sep="")
      desc <- results[i,]$description
      freq <- results[i,]$frequency
      colname <- results[i,]$columns$name
      if (!silent) {
        cat(name, "\nCode: ", code, "\nDesc: ", desc, "\nFreq: ", freq, "\nCols: ", paste(unlist(colname), collapse=" | "), "\n\n", sep="")
      }
    }
  } else {
    warning("No datasets found")
  }
  invisible(results)
}

#' Search all Blockwatch databases
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param query Search terms
#' @param silent Prints the results when FALSE (default).
#' @param per_page Number of results returned per page.
#' @param ... Additional named values that are sent as Blockwatch API parameters.
#' @return Search results returned as a data.frame.
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' search.results <- blockwatch.search("oil")
#' }
#' @export
blockwatch.search <- function(query, silent = FALSE, per_page = 10, ...) {
  params <- list()
  params$query <- query
  params$per_page <- per_page
  params <- c(params, list(...))

  path <- "database"
  json <- do.call(blockwatch.api, c(path=path, params))

  # results is a dataframe
  results <- structure(json$datasets, meta = json$meta)

  if (!is.null(nrow(results)) && nrow(results) > 0) {
    for (i in 1:nrow(results)) {
      name <- results[i,]$name
      code <- paste(results[i,]$database_code, "/", results[i,]$dataset_code, sep="")
      desc <- results[i,]$description
      freq <- results[i,]$frequency
      colname <- results[i,]$columns$name
      if (!silent) {
        cat(name, "\nCode: ", code, "\nDesc: ", desc, "\nFreq: ", freq, "\nCols: ", paste(unlist(colname), collapse=" | "), "\n\n", sep="")
      }
    }
  } else {
    warning("No datasets found")
  }
  invisible(results)
}

#' Help displays information about a Blockwatch database, dataset and datafields
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param code Database, dataset (DB/SET) or datafield (DB/SET/FIELD) code
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.help("BITFINEX:OHLCV")
#' }
#' @export
blockwatch.help <- function(code) {
  what <- strsplit(code, "/", fixed=TRUE)[[1]]
  result <- switch(length(what),
    do.call(blockwatch.api, c(path="databases", list())),
    do.call(blockwatch.api, c(path=paste("databases", code, "metadata", sep = "/"), list())),
    do.call(blockwatch.api, c(path=paste("databases", paste(what[1], what[2], sep="/"), "metadata", sep = "/"), list())),
  )
  if (!is.null(result)) {
    data <- switch(length(what),
      result$databases[which(result$databases$code == what[1]),],
      result,
      result$columns[which(result$columns$code == what[3]),]
    )
    switch(length(what),
      cat("Database",
        "\n  Code: ", data$code,
        "\n  Type: ", data$type,
        "\n  Desc: ", data$description,
        "\n  Docu: ", data$documentation, "\n"),
      cat("Dataset",
        "\n  Code: ", paste(data$database_code, data$dataset_code, sep="/"),
        "\n  Type: ", data$type,
        "\n  Desc: ", data$description, "\n"),
      cat("Datafield",
        "\n  Code: ", data$code,
        "\n  Type: ", data$type,
        "\n  Desc: ", data$desc, "\n"),
    )
  } else {
    warning("No description found")
  }
}

#' Lists subscribed databases
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param silent Prints the results when FALSE (default).
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.databases()
#' }
#' @export
blockwatch.databases <- function(silent = FALSE) {
  params <- list()
  json <- do.call(blockwatch.api, c(path="databases", params))
  # results is a dataframe
  results <- structure(json$databases, meta = json$meta)
  if (!is.null(nrow(results)) && nrow(results) > 0) {
    for (i in 1:nrow(results)) {
      name <- results[i,]$name
      code <- results[i,]$code
      type <- results[i,]$type
      desc <- results[i,]$description
      freq <- results[i,]$data_frequency
      deliv <- results[i,]$delivery_frequency
      if (!silent) {
        cat(name, "\n  Code:        ", code, "\n  Type:        ", type, "\n  Description: ", desc, "\n  Frequency:   ", freq, "\n  Delivery:    ", deliv, "\n\n", sep="")
      }
    }
  } else {
    warning("No databases found")
  }

  invisible(results)
}

#' Lists datasets
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param database_code Blockwatch database code.
#' @param silent Prints the results when FALSE (default).
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.datasets("BITFINEX:OHLCV")
#' }
#' @export
blockwatch.datasets <- function(database_code, silent = FALSE) {
  params <- list()
  path <- paste("databases", database_code, "codes", sep = "/")
  json <- do.call(blockwatch.api, c(path=path, params))

  if (length(json) == 0) {
    stop("No datasets found")
  }

  df <- data.frame(matrix(ncol = 2, nrow = 0))
  for (i in 1:nrow(json)) {
    df[1,i] <- paste(json[i,]$database_code, json[i,]$dataset_code, sep = "/")
    df[2,i] <- json[i,]$name
    if (!silent) {
      cat(df[1,i], "  ", df[2,i], "\n")
    }
  }
  invisible(df)
}

#' Lists datafields
#'
#' @details Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
#'
#' For instructions on finding your authentication token go to https://blockwatch.cc/account/profile#apikey
#' @param dataset_code Fully qualified Blockwatch dataset code (DB_CODE/SET_CODE).
#' @param silent Prints the results when FALSE (default).
#' @seealso \code{\link{blockwatch.api_key}}
#' @examples \dontrun{
#' blockwatch.datafields("BITFINEX:OHLCV/BTC_USD")
#' }
#' @export
blockwatch.datafields <- function(code, silent = FALSE) {
  params <- list()
  path <- paste("databases", code, "metadata", sep = "/")
  json <- do.call(blockwatch.api, c(path=path, params))

  if (length(json) == 0) {
    stop("No metadata found")
  }
  results <- structure(json$columns)
  if (!silent) {
    cat(format("Code", width = 15, justify = "left"),
      format("Type", width = 10, justify = "left"),
      "Description\n")
  }

  for (i in 1:nrow(json$columns)) {
    code <- results[i,]$code
    type <- results[i,]$type
    desc <- results[i,]$description
    if (!silent) {
      cat(format(code, width = 15, justify = "left"),
      format(type, width = 10, justify = "left"),
      desc, "\n")
    }
  }
  invisible(results)
}