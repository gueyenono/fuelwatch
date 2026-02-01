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
urls <- glue::glue(
  "https://business.rustonlincoln.org/list/?page={1:5}"
)

# Create function for scraping page ----
scrape_page <- function(url) {
  Sys.sleep(2)
  page <- read_html(url)
  
  business <- page |>
    html_elements("h3") |>
    html_text() |>
    str_squish()
  
  category <- page |>
    html_elements("p.mn-listing-categories") |>
    html_text() |>
    str_squish()
  
  tibble(
    business = business,
    category = category
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
  here::here(
    "./learn-webscraping/business_directory/business-data.csv"
  ),
  row.names = FALSE
)
