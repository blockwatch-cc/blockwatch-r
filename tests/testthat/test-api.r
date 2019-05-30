source("test-helpers.r")

context('Test api error handling')

context('blockwatch.api')
with_mock(
  `httr::content` = function(response, as="text") {
    "{}"
  },
  `httr::VERB` = function(http, url, config, body, query) {
    httr:::response(status_code = 500)
  },
  test_that('When status code is not 200 error is thrown', {
    expect_error(blockwatch.api('series'))
  })
)

context('blockwatch.api.download_file')
with_mock(
  `httr::content` = function(response, as="text") {
    "{}"
  },
  `httr::GET` = function(url, config, query, ...) {
    httr:::response(status_code = 403)
  },
  test_that('When status code is not 200 error is thrown', {
    expect_error(blockwatch.api.download_file('series', 'foobar'))
  })
)

context('blockwatch.api.build_request')
test_that('request headers and query params are constructed', {
  Blockwatch.api_key('test_key')
  Blockwatch.api_version('1')
  path <- 'series'
  results <- blockwatch.api.build_request(path, start_date = '2019-01-01', end_date = as.Date('2019-02-01'))
  expected_params <- list(start_date = '2019-01-01', end_date = '2019-02-01')
  expected_headers <- list(
      Accept = 'application/json, application/vnd.blockwatch.cc+json;version=1',
      `Request-Source` = 'R',
      `Request-Source-Version` = '1.0.2',
      `X-Api-Key` = 'test_key'
    )
  expected_url <- "https://data.blockwatch.cc/v1/series"
  expect_equal(results, list(request_url = expected_url, headers = expected_headers, params = expected_params))
})

context('blockwatch.api.build_query_params')
test_that('query params with array values are converted properly', {
  params <- list()
  params$param1 <- 'foo'
  params$param2 <- c('hello', 'world', 'bar')
  params$param3 <- 'cool'

  expected_params <- list(param1='foo', 'param2[]'='hello', 'param2[]'='world', 'param2[]'='bar', param3='cool')
  expect_equal(blockwatch.api.build_query_params(params), expected_params)
})

reset_config()
