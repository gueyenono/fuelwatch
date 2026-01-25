# Create URLs for all 50 pages ----
main_url <- "books.toscrape.com/"
main_urls <- glue::glue("https://books.toscrape.com/catalogue/page-{1:50}.html")

# Function to scrape book links ----
scrape_book_links <- function(page_url) {
  links <- rvest::read_html(x = page_url) |>
    rvest::html_elements(css = "div.image_container a") |>
    rvest::html_attr(name = "href")
  glue::glue("https://books.toscrape.com/catalogue/{links}")
}

book_urls <- purrr::map(.x = main_urls, .f = scrape_book_links) |>
  purrr::flatten_chr()

# Function to scrape book data ----
scrape_book_data <- function(book_url) {
  mainh <- rvest::read_html(x = book_url)
  title <- mainh |>
    rvest::html_element(css = "div.product_main h1") |>
    rvest::html_text()
  price <- mainh |>
    rvest::html_element(css = "p.price_color") |>
    rvest::html_text() |>
    stringr::str_extract(pattern = "\\d+\\.\\d+") |>
    as.numeric()
  data.frame(title, price)
}

safely_scrape_book_data <- purrr::safely(
  .f = scrape_book_data,
  otherwise = data.frame(title = NA, price = NA)
)

tictoc::tic()
book_data <- purrr::map_dfr(.x = book_urls, .f = safely_scrape_book_data)
tictoc::toc()

# Save data to disk ----
write.csv(
  x = book_data,
  file = here::here("learn-webscraping/books_info/books-info.csv"),
  row.names = FALSE
)
