# Import relevant packages ----
library(dplyr) # For data manipulation
library(glue) # For string concatenation
library(here) # For relative paths
library(janitor) # For cleaning column names
library(purrr) # For functional programming
library(rvest) # For webscraping
library(stringr) # For string manipulation

# Generate page URLs ----
urls <- glue::glue(
  "https://www.scrapethissite.com/pages/forms/?page_num={1:24}"
)

# Create function for scraping HTML table ----
scrape_table <- function(url) {
  Sys.sleep(2)
  rvest::read_html(url) |>
    rvest::html_element(css = "table.table") |>
    rvest::html_table()
}

# Scrape main HTML ----
tbls <- purrr::map(.x = urls, .f = scrape_table)

final <- tbls |>
  dplyr::bind_rows() |>
  janitor::clean_names() |>
  dplyr::rename(plus_minus = x)

# Write data to disk ----
write.csv(
  final,
  here::here(
    "./learn-webscraping/hockey_teams/hockey-data.csv"
  ),
  row.names = FALSE
)
