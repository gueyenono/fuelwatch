# Import packages ----
import requests

# url = "https://ipv4.icanhazip.com"
url = "https://www.gasbuddy.com/"
proxy = "geo.iproyal.com:12321"
proxy_auth = "bkms7LGsn8JU3hPI:hjVTmMdbd02nKrQR"
proxies = {
    "http": f"http://{proxy_auth}@{proxy}",
    "https": f"http://{proxy_auth}@{proxy}",
}

response = requests.get(url, proxies=proxies)
response = requests.get(url)
print(response.text)
