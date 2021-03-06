% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Blockwatchapi.R
\name{blockwatch.api}
\alias{blockwatch.api}
\title{Internal method to execute Blockwatch API calls}
\usage{
blockwatch.api(path, http = c("GET"), postdata = NULL, ...)
}
\arguments{
\item{path}{Path to api resource.}

\item{http}{Type of http request sent.}

\item{postdata}{A character or raw vector that is sent in a body.}

\item{...}{Named values that are interpretted as Blockwatch API parameters. Please see \url{https://blockwatch.cc/docs/api}.}
}
\value{
Blockwatch API response.
}
\description{
Internal method to execute Blockwatch API calls
}
\details{
Set your \code{api_key} with \code{blockwatch.api_key} function. For instructions on finding your api key go to \url{https://blockwatch.cc/account/profile#apikey}
}
\examples{
\dontrun{
blockwatchdata = blockwatch.api(path="series/BITFINEX:OHLCV/BTC_USD", http="GET")
plot(blockwatchdata[,1])
}
}
\seealso{
\code{\link{blockwatch.api_key}}
}
