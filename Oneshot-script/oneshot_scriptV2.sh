#!/bin/sh


cd ./Dockers/
docker compose up -d
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/initV2.sh
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/load_mapV2.sh
docker exec -it kg-open-street-map-ubuntu-1 sh -c /home/scripts/irdbcmapV2.sh