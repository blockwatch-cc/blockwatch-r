Blockwatch R Package
=========

This is Blockwatch's R package. The Blockwatch R package uses the [Blockwatch API](https://blockwatch.cc/docs/api). The official Blockwatch R package manual can be found [here](https://blockwatch.cc/docs/r).

For more information please contact alex@blockwatch.cc

# Installation

To install from Github via the [devtools](https://cran.r-project.org/package=devtools) package:

    install.packages("devtools")
    library(devtools)
    install_github("blockwatch-cc/blockwatch-r")

## CRAN

*Note: Blockwatch is not yet on CRAN, use Github method above.*

To install the most recent package from CRAN:

    install.packages("blockwatch")
    library(blockwatch)

Note that the version on CRAN might not reflect the most recent changes made to this package.

# Authentication

To make full use of the package we recommend you set your [api key](https://blockwatch.cc/docs/api#getting-started). To do this create or sign into your account and go to your [account api key page](https://blockwatch.cc/account/profile#apikey). Then input your API key (with quotes):

```r
blockwatch.api_key("APIKEY12345678")
```

# Usage

The Blockwatch package functions use the Blockwatch API. Optional Blockwatch API query parameters can be passed into each function. For more information on supported query parameters, please see the [Blockwatch API documentation page](https://blockwatch.cc/docs/api). Once you find the data you would like to load into R on Blockwatch, copy the Blockwatch code from the description box and paste it into the function.

```r
data <- blockwatch.series("BITFINEX:OHLCV/BTC_USD")
```

## Graphing Data Example

To create a graph of Bitcoin's performance month-over-month:

```r
plot(stl(blockwatch.series("BITFINEX:OHLCV/BTC_USD", datatype="ts", collapse="monthly")[,3],s.window="per"))
```

Note: `collapse` is a Blockwatch API query parameter. Click [here](https://blockwatch.cc/docs/api#time-series-api) for a full list of query parameter options.

## Return Types

The supported return types for the `blockwatch.series(code)` function are:
* raw (which returns a data.frame)
* [ts](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/ts.html)
* [zoo](https://cran.r-project.org/package=zoo)
* [xts](https://cran.r-project.org/package=xts)
* [timeSeries](https://cran.r-project.org/package=timeSeries)

To request a specific type, assign the `type` argument the return type:

```r
data <- blockwatch.series('BITFINEX:OHLCV/BTC_USD', datatype = "xts")
```

### Date Formats

zoo, xts, and ts have their own time series date formats. For example:

```r
data <- blockwatch.series('BITFINEX:OHLCV/BTC_USD', collapse = "weekly", datatype = "zoo", limit = 3)
```

`data` will have indexes `2018 Q1`, `2018 Q2`, and `2018 Q3`:

```r
        Open price Close price Highest price Lowest price Average price Trade count Buy count
2018 Q1     6925.3      7508.1        9990.0       6425.1      8236.767     4834496   2358593
2018 Q2     7508.1      7020.6        8506.7       5755.0      6866.010     5112258   2412164
2018 Q3     7020.5      4305.0        7788.0       3657.6      6275.323     4229066   2060333
        Sell count Base volume Quote volume Base volume buy side Quote volume buy side
2018 Q1    2475903     2066609  16842512450            1014616.5            8276759925
2018 Q2    2700094     2405368  16475286016            1133072.0            7771619735
2018 Q3    2168733     1985497  11659640076             931883.9            5459749590
        Base volume sell side Quote volume sell side Standard deviation Mean price
2018 Q1               1051992             8565752525          0.0341565   7508.088
2018 Q2               1272296             8703666281          1.8305689   7023.428
2018 Q3               1053613             6199890485          0.6380526   4306.060
```

If you want the time series index to be displayed as dates, you will need to set `force_irregular = TRUE`:

```r
data <- blockwatch.series('BITFINEX:OHLCV/BTC_USD', collapse = "quarterly", datatype = "zoo", limit = 3, force_irregular = TRUE)
```

`data` will now have indexes `2018-02-28`, `2018-05-30`, and `2018-08-29` (note that interval boundaries for monthly and quartery data aggregates may be imprecise right now):

```r
                    Open price Close price Highest price Lowest price Average price Trade count
2018-02-28 06:00:00     6925.3      7508.1        9990.0       6425.1      8236.767     4834496
2018-05-30 12:00:00     7508.1      7020.6        8506.7       5755.0      6866.010     5112258
2018-08-29 18:00:00     7020.5      4305.0        7788.0       3657.6      6275.323     4229066
                    Buy count Sell count Base volume Quote volume Base volume buy side
2018-02-28 06:00:00   2358593    2475903     2066609  16842512450            1014616.5
2018-05-30 12:00:00   2412164    2700094     2405368  16475286016            1133072.0
2018-08-29 18:00:00   2060333    2168733     1985497  11659640076             931883.9
                    Quote volume buy side Base volume sell side Quote volume sell side
2018-02-28 06:00:00            8276759925               1051992             8565752525
2018-05-30 12:00:00            7771619735               1272296             8703666281
2018-08-29 18:00:00            5459749590               1053613             6199890485
                    Standard deviation Mean price
2018-02-28 06:00:00          0.0341565   7508.088
2018-05-30 12:00:00          1.8305689   7023.428
2018-08-29 18:00:00          0.6380526   4306.060```

## Merged Dataset Data
If you want to get multiple codes at once, delimit the codes with ',', and put them into an array. This will return a multiset.

```r
merged_data <- blockwatch.series(c('BITFINEX:OHLCV/BTC_USD', 'BINANCE:OHLCV/_BTC_USDT'))
```

You can also specify specific columns to retrieve. For example, if you only want column `close` from `BITFINEX:OHLCV/BTC_USD` and column `close` from `PRICE/BINANCE_BTC_USDT`:

```r
merged_data <- blockwatch.series(c('BITFINEX:OHLCV/BTC_USD', 'BINANCE:OHLCV/BTC_USDT'), columns="close")
```

## Downloading Entire Database

An entire database's data cannot be downloaded at the moment. Please check back for updates.

## Datatables

To retrieve Datatable data, provide a Datatable code to the Blockwatch datatables function:

```r
data = blockwatch.table('BITFINEX:TRADE/BTC_USD')
```

The output format is `data.frame`. Given the volume of data stored in datatables, this call will retrieve the first page of the BITFINEX:TRADE/BTC_USD datatable. You may turn on pagination to return more data by using:

```r
data = blockwatch.table('BITFINEX:TRADE/BTC_USD', paginate=TRUE)
```

This will retrieve multiple pages of data and merge them together as if they were one large page. In some cases, however, you will still exceed the request limit. In this case we recommend you filter your data using the available query parameters, as in the following example:

```r
blockwatch.table('BITFINEX:TRADE/BTC_USD', time.gte='2019-01-01', columns='time,price,amount')
```

In this query we are asking for more pages of data, a trade time that is greater than or equal to 2019-01-01 and we are selecting only columns time, price and amount for return rather than all available columns.

## Search

Searching Blockwatch from within the R console is not supported right now. When available the search function will look like:

```r
blockwatch.search(query = "Search Term", page = n, database_code = "Specific database to search", silent = TRUE|FALSE)
```

* **query**: Required; Your search term, as a string
* **page**: Optional; page number of search you wish returned, defaults to 1.
* **limit**: Optional; number of results per page, defaults to 10 in the Blockwatch R package.
* **database_code**: Optional; Name of a specific database you wish to search, as a string
* **silent**: Optional; specifies whether you wish the first three results printed to the console, defaults to True (see example below).

Which outputs to console a list containing the following information for every item returned by the search:

* Name
* Blockwatch code
* Description
* Frequency
* Column names


### Example
A search for BTC in the BITFINEX:TRADE database.

```r
blockwatch.search("BTC", database_code = "BITFINEX:TRADE", limit = 3)
```

prints:

```r
TODO
```


# Additional Resources

More help can be found at [Blockwatch](https://blockwatch.cc) in our [R](https://blockwatch/docs/r) and [API](https://blockwatch.cc/docs/api) pages.

License provided by MIT. This package is loosely based on https://github.com/quandl/quandl-r created by Raymond McTaggart.
