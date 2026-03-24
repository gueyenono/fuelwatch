# Load the scraping functions ----
source(
  file = here::here("./learn-webscraping/houston_gas/scraping_functions.R")
)

#
chicago_url <- "https://www.gasbuddy.com/gasprices/illinois/chicago"

main_url <- "https://www.gasbuddy.com/"

urls <- scrape_all_station_urls(main_url = main_url)
