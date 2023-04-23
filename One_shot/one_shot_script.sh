#!/bin/sh

RELATION_NAME=$(grep -Po '(?<=\[Relation_Name\] : ")[^"]*' ./setup.config)
LOAD_TO_VIRTUOSO=$(grep -Po '(?<=\[Load_To_Virtuoso\] : ")[^"]*' ./setup.config)


cd ./../Dockers
docker compose up -d
docker exec -it kg-open-street-map-ubuntu-1 sh -c "/home/scripts/one_shot.sh $RELATION_NAME"

if [ $? -eq 0 ];
then 
    mkdir ./../Dockers/virtuoso_data/$RELATION_NAME
    cp ./../Dockers/maps/$RELATION_NAME/*.n3 ./../Dockers/virtuoso_data/$RELATION_NAME
    docker exec -it kg-open-street-map-ubuntu-1 sh -c "/home/scripts/load_to_virtuoso.sh $RELATION_NAME"
fi

