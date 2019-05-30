# source("test-helpers.r")

# context("Search calls databases endpoint")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     test_that("correct endpoint is called", {
#       expect_equal(url, "https://data.blockwatch.cc/v1/databases")
#     })
#     test_that("search query param is added", {
#       expect_equal(query$query, "BTC")
#     })
#     mock_response(content = mock_search_response())
#   },
#   `httr::content` = function(response, as = "text") {
#     response$content
#   },
#   Blockwatch.search("BTC")
# )

# context("Blockwatch.search with results")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     mock_response(content = mock_search_response())
#   },
#   `httr::content` = function(response, as = "text") {
#     response$content
#   },
#   test_that("Output message lists 3 codes", {
#     expect_output(Blockwatch.search("BTC"), "(Code: [A-Z0-9_]+/[A-Z0-9_]+.+){3}")
#   })
# )


# context("Blockwatch.search with no results")
# with_mock(
#   `httr::VERB` = function(http, url, config, body, query) {
#     mock_response(content = mock_search_empty_response())
#   },
#   `httr::content` = function(response, as = "text") {
#     response$content
#   },
#   test_that("Doesn't find anything", {
#     expect_warning(Blockwatch.search("asfdsgfrg"), "No databases found")
#   })
# )

# reset_config()
