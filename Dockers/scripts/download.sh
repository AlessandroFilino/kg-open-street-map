#!/bin/bash

CITY="montemignaio"

JSON=$(curl -s "https://nominatim.openstreetmap.org/search.php?q=${CITY}&format=json")
ID=$(echo "$JSON" | jq -r '.[0].osm_id')
echo $ID
LAT=$(echo $JSON | jq -r '.[0].boundingbox[0]')
LON=$(echo $JSON | jq -r '.[0].boundingbox[2]')
MINLAT=$(echo $JSON | jq -r '.[0].boundingbox[0]')
MAXLAT=$(echo $JSON | jq -r '.[0].boundingbox[1]')
MINLON=$(echo $JSON | jq -r '.[0].boundingbox[2]')
MAXLON=$(echo $JSON | jq -r '.[0].boundingbox[3]')

wget -O "/home/maps/${CITY}.osm" "https://api.openstreetmap.org/api/0.6/map?bbox=${MINLON},${MINLAT},${MAXLON},${MAXLAT}"
