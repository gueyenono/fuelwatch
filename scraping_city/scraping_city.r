# Load packages ----
library(dplyr)     # For data manipulation
library(glue)      # For string concatenation
library(here)      # For relative paths
library(janitor)   # For cleaning column names
library(purrr)     # For functional programming
library(rvest)     # For webscraping
library(stringr)   # For string manipulation
library(tibble)    # For tibbles

# Generate page URLs ----
urls <- c(
  "https://www.gasbuddy.com/gasprices/louisiana/alexandria"
)

# Create function for scraping page ----
scrape_page <- function(url) {
  Sys.sleep(2)
  page <- read_html_live(url)
  
  business <- page |>
    html_elements(css = ".StationDisplay-module__stationNameHeader___1A2q8 a") |>
    html_text() |>
    str_squish()
  
  price <- page |>
    html_elements(css = ".StationDisplayPrice-module__price___3rARL") |>
    html_text() |>
    str_squish() |>
    str_remove("\\$") |>
    as.numeric()

  
  tibble(
    business = business,
    price = price,
    location = "Alexandria, LA",
    Time_scraped = Sys.time()
  )
}

# Scrape all pages ----
tbls <- purrr::map(urls, scrape_page)

# Combine + clean ----
final <- tbls |>
  bind_rows() |>
  clean_names()

# Write data to disk ----
write.csv(
  final,
  "gas_prices.csv",
  row.names = FALSE
)
