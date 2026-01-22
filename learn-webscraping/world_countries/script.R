# Load packages ----
library(here) # For relative paths
library(stringr) # For string/text manipulation
library(rvest) # For webscraping

# Scrape the HTML ----

main_url <- "https://www.scrapethissite.com/pages/simple/"
main_html <- rvest::read_html(main_url)


# Scrape the data ----

country_names <- main_html |>
  rvest::html_elements(css = "h3.country-name") |>
  rvest::html_text() |>
  stringr::str_squish()

capitals <- main_html |>
  rvest::html_elements(css = "span.country-capital") |>
  rvest::html_text() |>
  stringr::str_squish()

population <- main_html |>
  rvest::html_elements(css = "span.country-population") |>
  rvest::html_text() |>
  as.numeric()

area <- main_html |>
  rvest::html_elements(css = "span.country-area") |>
  rvest::html_text() |>
  as.numeric()

# Write data to disk ----

final <- data.frame(
  country = country_names,
  capital = capitals,
  population,
  area
)

write.csv(
  final,
  here::here("learn-webscraping/world_countries/countries.csv"),
  row.names = FALSE
)
