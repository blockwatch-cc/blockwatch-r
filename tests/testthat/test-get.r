library("zoo")
library("xts")
library("timeSeries")
library("httr")
source("test-helpers.r")

context("Getting Dataset data")

context("Blockwatch() bad argument errors")
test_that("Invalid transform throws error", {
  expect_error(Blockwatch("BITFINEX:OHLCV/BTC_USD", transform = "blah"))
})

test_that("Invalid collapse throws error", {
  expect_error(Blockwatch("BITFINEX:OHLCV/BTC_USD", collapse = "blah"))
})

test_that("Invalid type throws error", {
  expect_error(Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "blah"))
})

context("Blockwatch() call")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    print(query)
    test_that("correct arguments are passed in", {
      expect_equal(http, "GET")
      expect_equal(url, "https://data.blockwatch.cc/v1/series/BITFINEX:OHLCV/BTC_USD.json")
      expect_null(body)
      expect_equal(query, list(start_date = "2019-01-01", transform = "rdiff",
                               collapse = "annual", order = "desc"))
    })
    mock_response()
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  Blockwatch("BITFINEX:OHLCV/BTC_USD", start_date = "2019-01-01", transform = "rdiff", collapse = "annual", order = "desc")
)

context("Blockwatch() daily data response")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    mock_response()
  },
  `httr::content` = function(response, as="text") {
    response$content
  },
  test_that("list names are set to column names", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD")
    expect_named(dataset, c("Timestamp", "Open price", "Close price", "Highest price",
      "Lowest price", "Average price", "Trade count", "Buy count", "Sell count",
      "Base volume", "Quote volume", "Base volume buy side", "Quote volume buy side",
      "Base volume sell side", "Quote volume sell side", "Standard deviation", "Mean price"))
  }),
  test_that("returned data is a dataframe", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD")
    expect_is(dataset, 'data.frame')
  }),
  # test_that("does contain meta attribute when requested", {
  #   dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", meta = TRUE)
  #   expect_true(!is.null(attr(dataset, "meta")))
  #   expect_equal(attr(dataset, "meta")$id, 6668)
  #   expect_equal(attr(dataset, "meta")$database_code, "NSE")
  #   expect_equal(attr(dataset, "meta")$dataset_code, "OIL")
  # }),
  test_that("zoo is returned when requested", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "zoo")
    expect_is(dataset, "zoo")
  }),
  test_that("xts is returned when requested", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "xts")
    expect_is(dataset, "xts")
  }),
  test_that("timeSeries is returned when requested", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "timeSeries")
    expect_is(dataset, "timeSeries")
  }),
  test_that("zoo is returned instead of ts if ts is not supported for frequency", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "ts")
    expect_is(dataset, "zoo")
  }),
  test_that("display warning message if type ts is not supported by frequency", {
    expect_warning(Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "ts"),
      "Type 'ts' does not support frequency 365. Returning zoo.", fixed = TRUE)
  })
)

context("Blockwatch() annual collapse response data")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    mock_response(content = mock_annual_data())
  },
  `httr::content` = function(response, as = "text") {
    response$content
  },
  test_that("return ts when requested", {
    dataset <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype = "ts", collapse = "annual")
    expect_is(dataset, "ts")
  }),
  test_that("Data is the same across formats", {
    annaulraw <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="raw", collapse = "annual")
    annaults <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="ts", collapse = "annual")
    annaulzoo <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="zoo", collapse = "annual")
    annaulxts <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="xts", collapse = "annual")
    annaultimeSeries <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="timeSeries")
    expect_equal(max(abs(annaults - coredata(annaulzoo))), 0)
    expect_equal(max(abs(coredata(annaulzoo) - coredata(annaulxts))) , 0)
    # timeSeries keeps data in same order as passed in, not chronological
    # Have to compare against raw as zoo and xts are sorted chronologically
    expect_equal(max(abs(annaulraw[,-1] - getDataPart(annaultimeSeries))), 0)
  }),
  test_that("When requesting xts annual warn user xts has non-standard meaning for frequency", {
    expect_warning(Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="xts", collapse = "annual"),
      "xts has a non-standard meaning for 'frequency'.", fixed = TRUE)
  })
)

# FIXME
# context("Blockwatch() monthly collapse response data")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     mock_response(content = mock_monthly_data())
#   },
#   `httr::content` = function(response, as = "text") {
#     response$content
#   },
#   test_that("Frequencies are correct across output formats", {
#     monthlyts <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="ts", collapse = "monthly")
#     monthlyzoo <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="zoo", collapse = "monthly")
#     monthlyxts <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="xts", collapse = "monthly")
#     monthlytimeSeries <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="timeSeries", collapse = "monthly")

#     expect_equal(frequency(monthlyts), 12)
#     expect_equal(frequency(monthlyzoo), 12)
#     expect_equal(frequency(monthlyxts), 12)
#     # timeSeries allows time index in reverse order but regularity checks won't work then
#     # So we check reversed series also
#     expect_true((frequency(monthlytimeSeries)==12)||(frequency(rev(monthlytimeSeries))==12))
#   })
# )

# FIXME
# context("Blockwatch() annual frequency response data")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     mock_response(content = mock_annual_frequency_data())
#   },
#   `httr::content` = function(response, as = "text") {
#     response$content
#   },
#   test_that("Start and end dates are correct (zoo)", {
#     annual <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="zoo")
#     expect_equal(start(annual), 2015)
#     expect_equal(end(annual), 2018)
#   }),
#     test_that("Start and end dates are correct (zoo) with force_irregular param set", {
#     annual <- Blockwatch("BITFINEX:OHLCV/BTC_USD", datatype="zoo", force_irregular = TRUE)
#     expect_equal(start(annual), as.Date("2015-05-01"))
#     expect_equal(end(annual), as.Date("2018-12-31"))
#   }),
#   test_that("Start and end dates are correct (xts)", {
#     annual <- Blockwatch("TESTS/4", datatype="xts")
#     expect_that(start(annual), is_equivalent_to(as.Date("2015-05-01")))
#     expect_that(end(annual), is_equivalent_to(as.Date("2018-12-31")))
#   }),
#   test_that("Start and end dates are correct (timeSeries)", {
#    annual <- Blockwatch("TESTS/4", datatype="timeSeries")
#    expect_that(start(annual), is_equivalent_to(as.timeDate("2015-05-01")))
#    expect_that(end(annual), is_equivalent_to(as.timeDate("2018-12-31")))
#   })
# )

context("Blockwatch() quarterly frequency response data")
with_mock(
  `httr::VERB` = function(http, url, config, body, query) {
    mock_response(content = mock_quarterly_collapse_data())
  },
  `httr::content` = function(response, as = "text") {
    response$content
  },
  test_that("Collapsed data frequency", {
    dailytoquart <- Blockwatch("TESTS/1", datatype="ts", collapse="quarterly")
    expect_equal(frequency(dailytoquart), 4)
  })
)

# context('Blockwatch() filtering by column index')
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     test_that("correct arguments are passed in", {
#       expect_equal(query$column, "id")
#     })
#     mock_response()
#   },
#   `httr::content` = function(response, as="text") {
#     response$content
#   },
#   Blockwatch("BITFINEX:OHLCV/BTC_USD.id")
# )

# context('Blockwatch() multiple datasets')
# test_that("Multiple dataset codes with dataset code column indexes are requested", {
#   database_codes <- c("NSE", "AAPL")
#   dataset_codes <- c("OIL", "WIKI")
#   requested_column_indexes <- c("1", "2")
#   i <- 0
#   with_mock(
#     `httr::VERB` = function(http, url, config, body, query) {
#       i <<- i + 1
#       test_that("request is made with correct params", {
#         expected_code <- paste(database_codes[i], dataset_codes[i], sep = "/")
#         expect_true(grepl(expected_code, url))
#         expect_equal(query$column_index, requested_column_indexes[i])
#         expect_equal(query$transform, "rdiff")
#       })
#       mock_response(content = mock_data(database_code = database_codes[i], dataset_code = dataset_codes[i]))
#     },
#     `httr::content` = function(response, as = "text") {
#       response$content
#     },
#     Blockwatch(c("BITFINEX:OHLCV/BTC_USD.1", "AAPL/WIKI.2"), transform = "rdiff", column_index = 3)
#   )
#   expect_equal(i, 2)
# })

# test_that("Multiple dataset codes calls merge", {
#   database_codes <- c("NSE", "AAPL", "TESTS")
#   dataset_codes <- c("OIL", "WIKI", "4")
#   i <- 0
#   with_mock(
#     `httr::VERB` = function(http, url, config, body, query) {
#       mock_response(content = mock_data(database_code = database_codes[i], dataset_code = dataset_codes[i]))
#     },
#     `httr::content` = function(response, as = "text") {
#       response$content
#     },
#     merge = function(data, merge_data, ...) {
#       i <<- i + 1
#     },
#     Blockwatch(c("BITFINEX:OHLCV/BTC_USD.1", "WIKI/AAPL.2", "TESTS/4.1"))
#   )
#   expect_equal(i, 2, info = "3 datasets are merged together, merged is called twice")
# })

# test_that("Multiple dataset codes returns desired requested datatype", {
#   with_mock(
#     `httr::VERB` = function(http, url, config, body, query) {
#       mock_response(content = mock_annual_data())
#     },
#     `httr::content` = function(response, as = "text") {
#       response$content
#     },
#     test_that("return datatype is correct", {
#       datatypes <- c('raw', 'ts', 'zoo', 'xts', 'timeSeries')
#       expected <- c('data.frame', 'ts', 'zoo', 'xts', 'timeSeries')
#       i <- 0
#       for(datatype in datatypes) {
#         i <- i + 1
#         dataset = Blockwatch(c("BITFINEX:OHLCV/BTC_USD.1", "WIKI/AAPL.2", "TESTS/4.1"), datatype = datatype, collapse = 'annual')
#         expect_is(dataset, expected[i])
#       }
#     })
#   )
# })

reset_config()
