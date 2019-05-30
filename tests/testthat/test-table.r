library("httr")
source("test-table-helper.r")
source("test-helpers.r")

context("Getting Datatable data")

context("Blockwatch.table() call")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    test_that("correct arguments are passed in", {
      expect_equal(http, "GET")
      expect_equal(url, "https://data.blockwatch.cc/v1/tables/BITFINEX:TRADE/BTC_USD.json")
      expect_null(body)
      expect_equal(query, list())
    })
    mock_response(content = mock_table_data())
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  Blockwatch.table("BITFINEX:TRADE/BTC_USD")
)

context("Blockwatch.table() call with options")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    test_that("correct arguments are passed in", {
      expect_equal(http, "GET")
      expect_equal(url, "https://data.blockwatch.cc/v1/tables/BITFINEX:TRADE/BTC_USD.json")
      expect_null(body)
      expect_equal(query, list(end_date.gt='2019-01-01',
                               'columns[]'='time', 'columns[]'='id',
                               'columns[]'='amount'))
    })
    mock_response(content = mock_table_data())
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  Blockwatch.table("BITFINEX:TRADE/BTC_USD",
                               end_date.gt='2019-01-01',
                               columns=c('time','id','amount'),
                    paginate=FALSE)
)

context("Blockwatch.table() response")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    mock_response(content = mock_table_data("\"cursor_foo_bar\""))
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  `Blockwatch:::blockwatch.table.max_rows` = function() {
    return(100)
  },
  test_that("warning message is displayed regarding more data when cursor_id is present in response", {
    expect_warning(Blockwatch.table('BITFINEX:TRADE/BTC_USD'),
                   paste("This call returns more data. To request more pages, please set paginate=TRUE",
                         "in your Blockwatch.table() call. For more information see our documentation:",
                         "https://github.com/blockwatch-cc/blockwatch-r/blob/master/README.md#tables"), fixed = TRUE)
  }),
  test_that("response data is data frame", {
    expect_is(Blockwatch.table('BITFINEX:TRADE/BTC_USD'), "data.frame")
  }),
  test_that("column names are set", {
    data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD')
    expect_equal(names(data), c("Trade ID", "Timestamp", "Price", "Amount", "Sell"))
  }),
  test_that("response data columns are converted to proper data types", {
    data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD')
    expect_is(data[,1], "numeric")
    expect_is(data[,2], "POSIXct")
    expect_is(data[,3], "numeric")
    expect_is(data[,4], "numeric")
    expect_is(data[,5], "logical")
  }),
  test_that("response data is one page if paginate=TRUE is not set", {
    data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD')
    expect_equal(nrow(data), 9)
  }),
  # # FIXME
  # test_that("response data contains max rows if paginate=TRUE is set", {
  #   data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD', paginate=TRUE)
  #   expect_equal(nrow(data), 100)
  # }),
  test_that("warning message is displayed when max number of rows fetched is reached", {
    expect_warning(Blockwatch.table('BITFINEX:TRADE/BTC_USD', paginate=TRUE),
      paste("This call returns a larger amount of data than Blockwatch.table() allows.",
            "Please view our documentation on developer methods to request more data.",
            "https://github.com/blockwatch-cc/blockwatch-r/blob/master/README.md#tables"), fixed = TRUE)
  })
)

# FIXME
# context("Blockwatch.table() empty data response")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     mock_response(content = mock_empty_table_data())
#   },
#   `httr::content` = function(response, as="text") {
#     response$content
#   },
#   test_that("empty response data columns are converted to proper data types", {
#     data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD')
#     expect_equal(nrow(data), 0)
#     expect_is(data[,1], "numeric")
#     expect_is(data[,2], "POSIXct")
#     expect_is(data[,3], "numeric")
#     expect_is(data[,4], "numeric")
#     expect_is(data[,5], "logical")
#   })
# )

context("Blockwatch.table() response new column types")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    mock_response(content = mock_table_data_extra_columns())
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  test_that("response data columns are converted to proper new data types", {
    data <- Blockwatch.table('BITFINEX:TRADE/BTC_USD')
    expect_is(data[,1], "numeric")
    expect_is(data[,2], "POSIXct")
  })
)
reset_config()
