# load packages ----
library(rvest)
library(stringr)
library(here)

# get the html  ----
mainh <- read_html("https://sandbox.oxylabs.io/products?page=1")
mainh <- read_html_live("https://sandbox.oxylabs.io/products?page=1")

#  main scraping  ---

# scraping game_mane ----

game_name <- mainh |>
  html_elements(css = "h4.title") |>
  html_text() |>
  str_squish()

# scraping descripttion ----

description <- mainh |>
  html_elements(css = ".eag3qlw5") |>
  html_text() |>
  str_squish()

# scraping price

price <- mainh |>
  html_elements(css = ".eag3qlw4 ") |>
  html_text() |>
  stringr::str_replace(pattern = "\\,", replacement = "\\.") |>
  readr::parse_number()

# scraping stock

stock_status <- mainh |>
  html_elements(css = ".eag3qlw4+ p") |>
  html_text()

# create the data frame

final <- tibble::tibble(
  game = game_name,
  description = description,
  price = price,
  stock = stock_status
)

# write it down
write.csv(final, here("game_data.csv"))

