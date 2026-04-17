import requests

url = "https://www.gasbuddy.com/gasprices/louisiana"
proxy = "geo.iproyal.com:12321"
proxy_auth = "bkms7LGsn8JU3hPI:hjVTmMdbd02nKrQR"
proxies = {
    "http": f"http://{proxy_auth}@{proxy}",
    "https": f"http://{proxy_auth}@{proxy}",
}

response = requests.get(url, proxies=proxies)
print(response.text)
