# Scrape gas station data ----

scrape_gas_station_data <- function(
  gas_station_url,
  user_agent = httr::user_agent(
    agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
  )
) {
  response <- httr::GET(
    url = gas_station_url,
    user_agent
  )

  html_raw <- rvest::read_html(x = response)

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


# Scrape "area" URLs ----

generate_css_classes <- function() {
  css_class <- c(
    ".DataGrid-module__link___1Pa9Z",
    ".AreaCountyList-module__grid___6Le8s+ .AreaCountyList-module__grid___6Le8s .DataGrid-module__link___1Pa9Z",
    ".AreaCountyList-module__areaItem___3c4w7 .DataGrid-module__link___1Pa9Z",
    ".StationDisplay-module__stationNameHeader___1A2q8 a"
  )
  names(css_class) <- c("state", "county", "city", "station")
  css_class
}


scrape_urls <- function(
  url,
  area_type,
  user_agent = httr::user_agent(
    agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
  ),
  css_class_vector = generate_css_classes()
) {
  css_class <- css_class_vector[area_type]

  response <- httr::GET(
    url = url,
    user_agent
  )

  endpoints <- rvest::read_html(x = response) |>
    html_elements(css = css_class) |>
    html_attr(name = "href")

  glue("https://www.gasbuddy.com{endpoints}")
}


# Get state
scrape_all_station_urls <- function(main_url) {
  state_urls <- scrape_urls(url = main_url, area_type = "state")

  county_urls <- purrr::map(.x = state_urls[1:2], .f = \(state_url) {
    scrape_urls(url = state_url, area_type = "county")
  }) |>
    purrr::flatten_chr()

  city_urls <- purrr::map(.x = county_urls[1:2], .f = \(county_url) {
    scrape_urls(url = county_url, area_type = "city")
  }) |>
    purrr::flatten_chr()

  station_urls <- purrr::map(.x = city_urls[1:2], .f = \(city_url) {
    scrape_urls(url = city_url, area_type = "station")
  }) |>
    purrr::flatten_chr()
}
