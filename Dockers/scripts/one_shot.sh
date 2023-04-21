#!/bin/sh


download_map(){
    RELATION_NAME=$1

    JSON=$(curl -s "https://nominatim.openstreetmap.org/search.php?q=${RELATION_NAME}&format=json")
    ID=$(echo "$JSON" | jq -r '.[0].osm_id')
    echo $ID
    LAT=$(echo $JSON | jq -r '.[0].boundingbox[0]')
    LON=$(echo $JSON | jq -r '.[0].boundingbox[2]')
    MINLAT=$(echo $JSON | jq -r '.[0].boundingbox[0]')
    MAXLAT=$(echo $JSON | jq -r '.[0].boundingbox[1]')
    MINLON=$(echo $JSON | jq -r '.[0].boundingbox[2]')
    MAXLON=$(echo $JSON | jq -r '.[0].boundingbox[3]')

    QUERY="[out:xml];(node($MINLAT,$MINLON,$MAXLAT,$MAXLON);way($MINLAT,$MINLON,$MAXLAT,$MAXLON);relation($MINLAT,$MINLON,$MAXLAT,$MAXLON);<;);out%20center%20meta;"

    wget -O "/home/maps/${RELATION_NAME}.osm" "http://overpass-api.de/api/interpreter?data=$QUERY"
    
    return $ID
}


RELATION_NAME=$1
OSM_ID=$(download_map $RELATION_NAME)
/home/scripts/init.sh
/home/scripts/load_map.sh $RELATION_NAME
/home/scripts/irdbcmap.sh $OSM_ID $RELATION_NAME
