# Load packages ----
library(rvest)
library(stringr)
library(here)
library( chromote )
library(glue)

# function to scrape the station urls

scrape_gas_station_url <- function(city_url){
  
  html_raw <- read_html_live(city_url) |>
    html_elements( css = ".StationDisplay-module__stationNameHeader___1A2q8 a") |>
    html_attr( name = "href")
  html_gast <- glue( "https://www.gasbuddy.com{gas_stat}")
}

# function to scrape the city urls

county_url <- "https://www.gasbuddy.com/gasprices/alabama/autauga/3098"
scrape_city_url <- function(county_url){
  
  city <- read_html_live(county_url) |>
    html_elements( css = ".DataGrid-module__link___1Pa9Z")|>
    html_attr( name = "href")
  
  html_cty <- glue("https://www.gasbuddy.com{city}")
}

# function to scrape the county urls

state_url <- "https://www.gasbuddy.com/gasprices/alabama"

scrape_county_url <- function(state_url){
 counties <- read_html_live(state_url) |> 
    html_elements( css = ".AreaCountyList-module__grid___6Le8s+ .AreaCountyList-module__grid___6Le8s .DataGrid-module__link___1Pa9Z")|>
    html_attr( name = "href")
  
  html_county <- glue("https://www.gasbuddy.com{counties}")
  
}

# founction to scrape the state urls

mainh <- "https://www.gasbuddy.com/gasprices"

scrape_state_url <- function(mainh){
  state_province <- read_html_live(mainh) |>
    html_elements( css = ".DataGrid-module__link___1Pa9Z")|>
    html_attr(name = "href")
  
  html_state_province <- glue("https://www.gasbuddy.com{state_province}")
  
}
