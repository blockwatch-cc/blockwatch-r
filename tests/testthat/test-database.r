source("test-helpers.r")

Blockwatch.api_key('test_key')
Blockwatch.api_version('1')

test_that("download database url is constructed correctly", {
  expected <- "https://data.blockwatch.cc/v1/databases/BITFINEXX:TRADE/BTC_USD/download?api_key=test_key&api_version=1&download_type=partial"
  expect_equal(Blockwatch.database.bulk_download_url("BITFINEXX:TRADE/BTC_USD", download_type = "partial"), expected)
})

with_mock(
  `Blockwatch:::blockwatch.api.download_file` = function(path, filename, ...) {
    test_that("correct arguments are passed to api layer", {
      params <- list(...)
      expect_equal(params$download_type, "partial")
      expect_equal(path, "databases/BITFINEXX:TRADE/BTC_USD/download")
      expect_equal(filename, "folder/exists/BITFINEXX_TRADE_BTC_USD.zip")
    })
  },
  Blockwatch.database.bulk_download_to_file("BITFINEXX:TRADE/BTC_USD", "folder/exists/BITFINEXX_TRADE_BTC_USD.zip", download_type = "partial")
)

reset_config()
