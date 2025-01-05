import socks
import socket
import requests

def set_proxy(country):
    # Dictionary of proxy addresses by country
    proxies = {
        "US": "us.proxy.example.com:1080"
        "UK": "uk.proxy.example.com:1080",
        "FR": "fr.proxy.example.com:1080",
        "JP": "jp.proxy.example.com:1080"
    }
    
    if country not in proxies:
        return(f"Your country {country} not found in database.")
        return False
    
    proxy = proxies[country]
    host, port = proxy.split(":")
    
    socks.set_default_proxy(socks.SOCKS5, host, int(port))
    socket.socket = socks.socksocket
    print(f"Proxy set for {country}.")
    return True

def check_ip():
    try:
        response = requests.get("http://ipinfo.io/ip")
        print(f"Your IP address is: {response.text.strip()}")
    except requests.RequestException as e:
        print(f"Error checking IP address: {e}")

if __name__ == "__main__":
    country = input("Enter the country code (e.g., US, UK, FR, JP): ").strip().upper()
    if set_proxy(country):
        check_ip()
    else:
        print("Failed to set proxy.")
