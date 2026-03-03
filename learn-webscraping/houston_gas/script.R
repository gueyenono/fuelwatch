# Load packages ----
library(rvest)
library(stringr)
library(here)
library(chromote)
library(glue)


# get main html ----

# mainh <- read_html_live("https://www.gasbuddy.com/gasprices/texas/houston" )

mainh <- read_htmle("https://www.gasbuddy.com/gasprices")

h <- "https://www.gasbuddy.com"


# get the link to the state and province ----
sp <- mainh |>
  html_elements(css = ".DataGrid-module__link___1Pa9Z") |>
  html_attr(name = "href")
html_ap <- glue("{h}{sp}")


# get all the links of each state's counties ----

counties <- read_html_live("https://www.gasbuddy.com/gasprices/texas") |>
  html_elements(
    css = ".AreaCountyList-module__grid___6Le8s+ .AreaCountyList-module__grid___6Le8s .DataGrid-module__link___1Pa9Z"
  ) |>
  html_attr(name = "href")

html_county <- glue("https://www.gasbuddy.com{counties}")


# -----------------------------------------------

# get the link of each city of each county ---

city <- read_html_live(
  "https://www.gasbuddy.com/gasprices/texas/harris/3094"
) |>
  html_elements(css = ".DataGrid-module__link___1Pa9Z") |>
  html_attr(name = "href")

html_cty <- glue("https://www.gasbuddy.com{city}")


# ---------------------------------------------

# get the link of each gas station ----

gas_stat <- read_html_live(
  "https://www.gasbuddy.com/gasprices/texas/south-houston"
) |>
  html_elements(css = ".StationDisplay-module__stationNameHeader___1A2q8 a") |>
  html_attr(name = "href")
html_gast <- glue("https://www.gasbuddy.com{gas_stat}")

# get information on the stations -----

# get station name

name <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(css = ".StationInfoBox-module__header___2cjCS span") |>
  html_text()

# get station location

location <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(
    css = ".StationInfoBox-module__ellipsisNoWrap___1-lh5 , .StationInfoBox-module__ellipsisNoWrap___1-lh5 span"
  ) |>
  html_text()

# get gas price for regular grade

rprice <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(css = ".FuelTypePriceDisplay-module__price___3iizb") |>
  html_text()

# get gas price for midgrade

mprice <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(
    css = ".GasPriceCollection-module__priceDisplay___1pnaL:nth-child(2) .FuelTypePriceDisplay-module__price___3iizb"
  ) |>
  html_text()


# get price for premium

pprice <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(
    css = ".GasPriceCollection-module__priceDisplay___1pnaL~ .GasPriceCollection-module__priceDisplay___1pnaL+ .GasPriceCollection-module__priceDisplay___1pnaL .FuelTypePriceDisplay-module__price___3iizb"
  ) |>
  html_text()


# get the station rating

rating <- read_html_live("https://www.gasbuddy.com/station/81176") |>
  html_element(css = ".Station-module__ratingAverage___1UeHL") |>
  html_text()
