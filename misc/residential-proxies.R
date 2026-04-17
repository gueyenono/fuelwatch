library(httr2)

resp2 <- request("https://www.gasbuddy.com/gasprices/louisiana") |>
  httr2::req_proxy(
    url = "geo.iproyal.com", # e.g. geo.iproyal.com
    port = 12321, # your assigned port
    username = "bkms7LGsn8JU3hPI",
    password = "hjVTmMdbd02nKrQR"
  ) |>
  httr2::req_headers(
    `User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    `Accept` = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    `Accept-Language` = "en-US,en;q=0.5"
  ) |>
  httr2::req_perform()

# ----

url <- "https://www.gasbuddy.com/gasprices/louisiana"
proxy_url <- "http://bkms7LGsn8JU3hPI:hjVTmMdbd02nKrQR@HOST:12321"

r <- httr2::request(url) |>
  req_user_agent(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36"
  ) |>
  req_proxy(proxy_url) |>
  req_perform()

# ---

library(httr2)

# Test your real IP
request("https://www.gasbuddy.com/") |> req_perform() |> resp_status()

# Test through proxy
request("https://www.gasbuddy.com/") |>
  req_proxy(
    url = "geo.iproyal.com", # e.g. geo.iproyal.com
    port = 12321, # your assigned port
    username = "bkms7LGsn8JU3hPI",
    password = "hjVTmMdbd02nKrQR"
  ) |>
  req_perform() |>
  resp_status()

# ----

library(httr)

resp <- GET(
  "https://www.gasbuddy.com/gasprices/louisiana",
  use_proxy(
    url = "geo.iproyal.com", # e.g. geo.iproyal.com
    port = 12321, # your assigned port
    username = "bkms7LGsn8JU3hPI",
    password = "hjVTmMdbd02nKrQR"
  ),
  add_headers(
    `User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
  )
)
rvest::read_html(resp)
