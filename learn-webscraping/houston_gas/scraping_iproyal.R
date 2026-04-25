# WARNING: gasbuddy cannot be scraped without proxies ----

# Main URL + proxy info ----
url <- "https://www.gasbuddy.com/gasprices/alabama"
proxy <- "geo.iproyal.com:12321"
proxy_username <- "bkms7LGsn8JU3hPI"
proxy_password <- "hjVTmMdbd02nKrQR"
proxy_auth <- glue::glue("{proxy_username}:{proxy_password}")
proxy_full <- glue::glue("http://{proxy_auth}@{proxy}")

# Get HTML without proxy ----

req <- httr2::request(base_url = url) |>
  httr2::req_proxy(
    url = url,
    port = 12321,
    username = "bkms7LGsn8JU3hPI",
    password = "hjVTmMdbd02nKrQR"
  ) |>
  httr2::req_perform()
