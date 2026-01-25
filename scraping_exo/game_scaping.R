# load packages ----
library(rvest)
library(stringr)
library(here)

# get the html  ----
mainh <- read_html("https://sandbox.oxylabs.io/products?page=1")

#  main scraping  ---

  # scraping game_mane ----

 game_name <- mainh |> 
  html_elements(css = "h4.title") |>
  html_text() |>
  str_squish()
 
 # scraping descripttion ----
 
  description <- mainh |> 
   html_elements(css = ".eag3qlw5")  |>
   html_text() |>
   str_squish()
  
  # scraping price
  
    price <- mainh |> 
    html_elements(css = ".eag3qlw4 ")  |>
    html_text() |>
    str_squish()
  
  # scraping stock
  
 # create the data frame

  final <- data.frame(
    game = game_name,
    decription = description,
    price = price
  )
  
  # write it down
   write.csv( final,here("game_data.csv"))
  
 