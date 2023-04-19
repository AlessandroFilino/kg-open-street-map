from geopy.geocoders import Nominatim
import requests

# Indirizzo della città
city_address = "Montemignaio, Italia"

# Inizializza il geocodificatore Nominatim
geolocator = Nominatim(user_agent="my-application")

# Ottieni le coordinate della città
location = geolocator.geocode(city_address)
lat = location.latitude
lon = location.longitude

# Scarica i dati OSM dell'area circostante alle coordinate
bbox = f"{lon-0.01},{lat-0.01},{lon+0.01},{lat+0.01}"
url = f"https://api.openstreetmap.org/api/0.6/map?b