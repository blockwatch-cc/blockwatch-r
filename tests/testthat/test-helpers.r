reset_config <- function() {
  Blockwatch.api_key(NULL)
  Blockwatch:::Blockwatch.api_version(NULL)
}

mock_data <- function(database_code = "BITFINEX:OHLCV", dataset_code = "BTC_USD") {
  "{\"columns\": [{ \"name\": \"Timestamp\", \"code\": \"time\", \"type\": \"datetime\"},
      { \"name\": \"Open price\", \"code\": \"open\", \"type\": \"float64\"},
      { \"name\": \"Close price\", \"code\": \"close\", \"type\": \"float64\"},
      { \"name\": \"Highest price\", \"code\": \"high\", \"type\": \"float64\"},
      { \"name\": \"Lowest price\", \"code\": \"low\", \"type\": \"float64\"},
      { \"name\": \"Average price\", \"code\": \"vwap\", \"type\": \"float64\"},
      { \"name\": \"Trade count\", \"code\": \"n_trades\", \"type\": \"int64\"},
      { \"name\": \"Buy count\", \"code\": \"n_buy\", \"type\": \"int64\"},
      { \"name\": \"Sell count\", \"code\": \"n_sell\", \"type\": \"int64\"},
      { \"name\": \"Base volume\", \"code\": \"vol_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume\", \"code\": \"vol_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume buy side\", \"code\": \"vol_buy_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume buy side\", \"code\": \"vol_buy_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume sell side\", \"code\": \"vol_sell_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume sell side\", \"code\": \"vol_sell_quote\", \"type\": \"float64\"},
      { \"name\": \"Standard deviation\", \"code\": \"stddev\", \"type\": \"float64\"},
      { \"name\": \"Mean price\", \"code\": \"mean\", \"type\": \"float64\"}],
     \"limit\":1000,
     \"count\":2,
     \"transform\":null,
     \"start_date\":1546300800000,
     \"end_date\":1549904400000,
     \"data\":[[1546304400000, 3835.04869856, 3829.1461377, 3840.1, 3819, 3832.260074577819, 1434, 1005, 429, 375.6896892099998, 1439243.1997972766, 251.38223024999994, 963262.3469791437, 124.30745896, 475980.85281813296, 0.20678243058610835, 3828.93369288875],
              [1546300800000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897]],
     \"collapse\":\"1h\",
     \"order\":\"desc\"
  }"
}

mock_annual_data <- function() {
  "{\"columns\": [{ \"name\": \"Timestamp\", \"code\": \"time\", \"type\": \"datetime\"},
      { \"name\": \"Open price\", \"code\": \"open\", \"type\": \"float64\"},
      { \"name\": \"Close price\", \"code\": \"close\", \"type\": \"float64\"},
      { \"name\": \"Highest price\", \"code\": \"high\", \"type\": \"float64\"},
      { \"name\": \"Lowest price\", \"code\": \"low\", \"type\": \"float64\"},
      { \"name\": \"Average price\", \"code\": \"vwap\", \"type\": \"float64\"},
      { \"name\": \"Trade count\", \"code\": \"n_trades\", \"type\": \"int64\"},
      { \"name\": \"Buy count\", \"code\": \"n_buy\", \"type\": \"int64\"},
      { \"name\": \"Sell count\", \"code\": \"n_sell\", \"type\": \"int64\"},
      { \"name\": \"Base volume\", \"code\": \"vol_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume\", \"code\": \"vol_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume buy side\", \"code\": \"vol_buy_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume buy side\", \"code\": \"vol_buy_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume sell side\", \"code\": \"vol_sell_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume sell side\", \"code\": \"vol_sell_quote\", \"type\": \"float64\"},
      { \"name\": \"Standard deviation\", \"code\": \"stddev\", \"type\": \"float64\"},
      { \"name\": \"Mean price\", \"code\": \"mean\", \"type\": \"float64\"}],
     \"limit\":1000,
     \"count\":4,
     \"transform\":null,
     \"start_date\":1430438404000,
     \"end_date\":1549904400000,
     \"data\":[[1430438404000, 3835.04869856, 3829.1461377, 3840.1, 3819, 3832.260074577819, 1434, 1005, 429, 375.6896892099998, 1439243.1997972766, 251.38223024999994, 963262.3469791437, 124.30745896, 475980.85281813296, 0.20678243058610835, 3828.93369288875],
              [1451606400000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897],
              [1483228800000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897],
              [1514764800000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897]],
     \"collapse\":\"1y\",
     \"order\":\"desc\"
  }"
}

mock_monthly_data <- function() {
  "{\"columns\": [{ \"name\": \"Timestamp\", \"code\": \"time\", \"type\": \"datetime\"},
      { \"name\": \"Open price\", \"code\": \"open\", \"type\": \"float64\"},
      { \"name\": \"Close price\", \"code\": \"close\", \"type\": \"float64\"},
      { \"name\": \"Highest price\", \"code\": \"high\", \"type\": \"float64\"},
      { \"name\": \"Lowest price\", \"code\": \"low\", \"type\": \"float64\"},
      { \"name\": \"Average price\", \"code\": \"vwap\", \"type\": \"float64\"},
      { \"name\": \"Trade count\", \"code\": \"n_trades\", \"type\": \"int64\"},
      { \"name\": \"Buy count\", \"code\": \"n_buy\", \"type\": \"int64\"},
      { \"name\": \"Sell count\", \"code\": \"n_sell\", \"type\": \"int64\"},
      { \"name\": \"Base volume\", \"code\": \"vol_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume\", \"code\": \"vol_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume buy side\", \"code\": \"vol_buy_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume buy side\", \"code\": \"vol_buy_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume sell side\", \"code\": \"vol_sell_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume sell side\", \"code\": \"vol_sell_quote\", \"type\": \"float64\"},
      { \"name\": \"Standard deviation\", \"code\": \"stddev\", \"type\": \"float64\"},
      { \"name\": \"Mean price\", \"code\": \"mean\", \"type\": \"float64\"}],
     \"limit\":1000,
     \"count\":3,
     \"transform\":null,
     \"start_date\":1522648800000,
     \"end_date\":1517392800000,
     \"data\":[[1522648800000, 6904.9, 9237.9, 9767.4, 6500.2, 8036.183540552245, 2738705, 1351918, 1386787, 1211826.5978248848, 9688241968.137804, 604491.2158863199, 4834070382.410645, 607335.3819385624, 4854171585.727097, 2.810960050923906, 9239.218815481963],
        [1520020800000, 10931, 6904.9, 11700, 6425.1, 8820.89485931053, 4015285, 1977422, 2037863, 1792724.7491147392, 15367791714.42389, 859868.6619947242, 7377578424.205611, 932856.087120014, 7990213290.218378, 0.05477225575046956, 6904.949999999999],
        [1517392800000, 10131, 10931, 11788, 6000, 9491.40270223286, 4798255, 2350553, 2447702, 2005977.1804647804, 18244308962.21597, 972162.1682308556, 8880079651.819094, 1033815.0122339174, 9364229310.396818, 3.4682148816336946, 10927.549668583692]],
     \"collapse\":\"1M\",
     \"order\":\"desc\"
  }"}

mock_annual_frequency_data <- function() {
  "{\"columns\": [{ \"name\": \"Timestamp\", \"code\": \"time\", \"type\": \"datetime\"},
      { \"name\": \"Open price\", \"code\": \"open\", \"type\": \"float64\"},
      { \"name\": \"Close price\", \"code\": \"close\", \"type\": \"float64\"},
      { \"name\": \"Highest price\", \"code\": \"high\", \"type\": \"float64\"},
      { \"name\": \"Lowest price\", \"code\": \"low\", \"type\": \"float64\"},
      { \"name\": \"Average price\", \"code\": \"vwap\", \"type\": \"float64\"},
      { \"name\": \"Trade count\", \"code\": \"n_trades\", \"type\": \"int64\"},
      { \"name\": \"Buy count\", \"code\": \"n_buy\", \"type\": \"int64\"},
      { \"name\": \"Sell count\", \"code\": \"n_sell\", \"type\": \"int64\"},
      { \"name\": \"Base volume\", \"code\": \"vol_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume\", \"code\": \"vol_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume buy side\", \"code\": \"vol_buy_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume buy side\", \"code\": \"vol_buy_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume sell side\", \"code\": \"vol_sell_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume sell side\", \"code\": \"vol_sell_quote\", \"type\": \"float64\"},
      { \"name\": \"Standard deviation\", \"code\": \"stddev\", \"type\": \"float64\"},
      { \"name\": \"Mean price\", \"code\": \"mean\", \"type\": \"float64\"}],
     \"limit\":1000,
     \"count\":4,
     \"transform\":null,
     \"start_date\":1430438404000,
     \"end_date\":1514764800000,
     \"data\":[[1430438404000, 3835.04869856, 3829.1461377, 3840.1, 3819, 3832.260074577819, 1434, 1005, 429, 375.6896892099998, 1439243.1997972766, 251.38223024999994, 963262.3469791437, 124.30745896, 475980.85281813296, 0.20678243058610835, 3828.93369288875],
              [1451606400000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897],
              [1483228800000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897],
              [1514764800000, 3832.6286242, 3835.16350319, 3846.2, 3822.4, 3832.7419887037863, 890, 598, 292, 265.35481187, 1017480.5220777779, 169.95881449999993, 651898.5430901253, 95.39599737000002, 365581.9789876522, 2.022511141792157, 3833.0195972357897]],
     \"collapse\":\"1y\",
     \"order\":\"desc\"
  }"
}

mock_quarterly_collapse_data <- function() {
  "{\"columns\": [{ \"name\": \"Timestamp\", \"code\": \"time\", \"type\": \"datetime\"},
      { \"name\": \"Open price\", \"code\": \"open\", \"type\": \"float64\"},
      { \"name\": \"Close price\", \"code\": \"close\", \"type\": \"float64\"},
      { \"name\": \"Highest price\", \"code\": \"high\", \"type\": \"float64\"},
      { \"name\": \"Lowest price\", \"code\": \"low\", \"type\": \"float64\"},
      { \"name\": \"Average price\", \"code\": \"vwap\", \"type\": \"float64\"},
      { \"name\": \"Trade count\", \"code\": \"n_trades\", \"type\": \"int64\"},
      { \"name\": \"Buy count\", \"code\": \"n_buy\", \"type\": \"int64\"},
      { \"name\": \"Sell count\", \"code\": \"n_sell\", \"type\": \"int64\"},
      { \"name\": \"Base volume\", \"code\": \"vol_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume\", \"code\": \"vol_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume buy side\", \"code\": \"vol_buy_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume buy side\", \"code\": \"vol_buy_quote\", \"type\": \"float64\"},
      { \"name\": \"Base volume sell side\", \"code\": \"vol_sell_base\", \"type\": \"float64\"},
      { \"name\": \"Quote volume sell side\", \"code\": \"vol_sell_quote\", \"type\": \"float64\"},
      { \"name\": \"Standard deviation\", \"code\": \"stddev\", \"type\": \"float64\"},
      { \"name\": \"Mean price\", \"code\": \"mean\", \"type\": \"float64\"}],
     \"limit\":1000,
     \"count\":4,
     \"transform\":null,
     \"start_date\":1520056800000,
     \"end_date\":1535824800000,
     \"data\":[[1535824800000, 7194.9, 6621.9, 7429.2, 6100, 6585.044477974599, 1331314, 622006, 709308, 633951.8728658047, 4207843122.8275895, 290370.4588014993, 1920972475.0078728, 343581.41406429437, 2286870647.819738, 0.12135202033683487, 6621.916105718461],
        [1527940800000, 7647.8, 7194.9, 8506.7, 5755, 6849.776780481315, 5100337, 2401303, 2699034, 2407093.9706545235, 16456866356.5477, 1133756.396457942, 7761462612.572386, 1273337.5741966378, 8695403743.975307, 0.035355339059494714, 7194.9125],
        [1520056800000, 11339, 7647.8, 11700, 6425.1, 8412.468542829161, 8799206, 4314287, 4484919, 3839621.3691442134, 32058435185.27633, 1864305.3446710373, 15568861232.054794, 1975316.024473198, 16489573953.221178, 0.16255644278624531, 7648.286072353334]],
     \"collapse\":\"3M\",
     \"order\":\"desc\"
  }"}

# mock_search_empty_response <- function() {
#   "{\"datasets\":[],\"meta\":{\"query\":\"sdfsdfdsfsdf\",\"per_page\":10,\"current_page\":1,\"prev_page\":null,\"total_pages\":0,\"total_count\":0}}"
# }

# mock_search_response <- function() {
#   "{\"datasets\":[
#     {
#       \"id\":6668,
#       \"dataset_code\":\"BTC_USD\",
#       \"database_code\":\"BITFINEX:OHLCV\",
#       \"name\":\"Bitfinex Bitcoin/USD\",
#       \"description\":\"Historical prices for Bitfinex Bitcoin/USD\\u003cbr\\u003e\\u003cbr\\u003eNational Stock Exchange of India\\u003cbr\\u003e\\u003cbr\\u003eTicker: BTC_USD\\u003cbr\\u003e\\u003cbr\\u003eISIN: INE274J01014\",
#       \"refreshed_at\":\"2015-08-08T03:23:52.573Z\",
#       \"newest_available_date\":\"2015-08-07\",
#       \"oldest_available_date\":\"2009-09-30\",
#       \"column_names\":[\"Date\",\"Open\",\"High\",\"Low\",\"Last\",\"Close\",\"Total Trade Quantity\",\"Turnover (Lacs)\"],
#       \"frequency\":\"daily\",
#       \"type\":\"Time Series\",
#       \"premium\":false,
#       \"database_id\":33
#     },
#     {
#       \"id\":20002963,
#       \"dataset_code\":\"BTC_USD\",
#       \"database_code\":\"XTSX\",
#       \"name\":\"LGX Oil \\u0026 Gas Inc (BTC_USD) Adjusted Stock Prices\",
#       \"description\":\" \\u003cb\\u003eTicker\",
#       \"refreshed_at\":\"2015-03-05T16:05:18.000Z\",
#       \"newest_available_date\":\"2015-03-04\",
#       \"oldest_available_date\":\"2015-02-17\",
#       \"column_names\":[\"Date\",\"Open\",\"High\",\"Low\",\"Close\",\"Volume\",\"Adjustment Factor\",\"Adjustment Type\"],
#       \"frequency\":\"daily\",
#       \"type\":\"Time Series\",
#       \"premium\":true,
#       \"database_id\":13187
#     },
#     {
#       \"id\":1994252,
#       \"dataset_code\":\"BTC_USD\",
#       \"database_code\":\"ECONWEBINS\",
#       \"name\":\"Crude Oil Prices 1861-1999\",
#       \"description\":\"U.S. Dollars per barrel. Source:BP, 1861-1944:US Average\",
#       \"refreshed_at\":\"2014-09-10T23:21:53.002Z\",
#       \"newest_available_date\":\"1999-12-31\",
#       \"oldest_available_date\":\"1861-12-31\",
#       \"column_names\":[\"Year\",\"$ (Money of the Day)\",\"$ (1999)\"],
#       \"frequency\":\"annual\",
#       \"type\":\"Time Series\",
#       \"premium\":false,
#       \"database_id\":247
#     }],
#     \"meta\":{
#       \"query\":\"oil\",
#       \"per_page\":3,
#       \"current_page\":1,
#       \"prev_page\":null,
#       \"total_pages\":149466,
#       \"total_count\":448398,
#       \"next_page\":2,
#       \"current_first_item\":1,
#       \"current_last_item\":3
#     }
#   }"
# }

mock_response <- function(status_code = 200,
 content = mock_data()) {
  httr:::response(
    status_code = status_code,
    content = content
  )
}