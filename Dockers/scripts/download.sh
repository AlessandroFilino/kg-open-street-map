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

QUERY="node($MINLAT,$MINLON,$MAXLAT,$MAXLON);way($MINLAT,$MINLON,$MAXLAT,$MAXLON);(._;>;);out;"

wget -O "/home/maps/${CITY}.osm" "http://overpass-api.de/api/interpreter?data=$QUERY"
