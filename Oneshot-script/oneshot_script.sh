#!/bin/sh


wget https://github.com/AlessandroFilino/kg-open-street-map/archive/refs/tags/v1.0.0.zip
unzip ./v1.0.0.zip
rm ./v1.0.0.zip
wget -P ./kg-open-street-map-1.0.0/Dockers/scripts/ https://github.com/AlessandroFilino/kg-open-street-map/releases/download/v1.0.0/sparqlify.zip
wget -P ./kg-open-street-map-1.0.0/Dockers/maps https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf 
cd ./kg-open-street-map-1.0.0/Dockers/
docker compose up -d
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/init.sh
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/load_map.sh
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/irdbcmap.sh