# Scrape gas station data ----

# > Set user agent

# ua <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
# user_agent <- httr::user_agent(agent = ua)
# # gas_station_url <- "https://www.gasbuddy.com/station/79221"
# gas_station_url <- "https://www.gasbuddy.com/station/206225"
#
# scrape_gas_station_data(
#   gas_station_url = gas_station_url,
#   user_agent = user_agent
# )

scrape_gas_station_data <- function(gas_station_url, user_agent) {
  html_raw <- rvest::read_html_live(url = gas_station_url)

  name <- html_raw |>
    html_element(css = ".StationInfoBox-module__header___2cjCS span") |>
    html_text()

  location <- html_raw |>
    html_element(
      css = ".StationInfoBox-module__ellipsisNoWrap___1-lh5 , .StationInfoBox-module__ellipsisNoWrap___1-lh5 span"
    ) |>
    html_text()

  gas_grades <- html_raw |>
    rvest::html_elements(
      css = ".GasPriceCollection-module__collectionContainer___29Ngz .GasPriceCollection-module__row___2JDQq:nth-child(1) .GasPriceCollection-module__column___3Nv5B > span"
    ) |>
    rvest::html_text()

  gas_prices <- html_raw |>
    rvest::html_elements(css = ".FuelTypePriceDisplay-module__price___3iizb") |>
    html_text()

  names(gas_prices) <- gas_grades

  rating <- html_raw |>
    html_element(css = ".Station-module__ratingAverage___1UeHL") |>
    html_text()

  out1 <- tibble::tibble(name, location, rating)
  out2 <- tibble::as_tibble(t(gas_prices))

  dplyr::bind_cols(out1, out2) |>
    tidyr::pivot_longer(
      cols = -c(name, location, rating),
      names_to = "grade",
      values_to = "price"
    )
}
