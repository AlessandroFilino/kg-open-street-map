#!/bin/sh
osmosis=/home/scripts/tools/osmosis/bin/osmosis
OSM_ID=$1
RELATION_NAME=$2
MAP_TYPE=$3
BBOX_LEFT=$6
BBOX_RIGHT=$7
BBOX_TOP=$5
BBOX_BOTTOM=$4


if [ ! -d /home/maps/$OSM_ID ]; then
    mkdir /home/maps/$OSM_ID
else
    rm -r /home/maps/$OSM_ID
    mkdir /home/maps/$OSM_ID
fi

cp /home/scripts/pgsimple_load_0.6.sql /home/maps/$OSM_ID

if [ $MAP_TYPE = "osm" ]; then
    $osmosis --read-xml  /home/maps/$OSM_ID.osm --log-progress --write-pgsimp-dump directory=/home/maps/$OSM_ID/ enableBboxBuilder=yes enableLinestringBuilder=yes
elif [ $MAP_TYPE = "pbf" ]; then
    # Filtriamo la mappa in base al bbox di interesse
    # echo $BBOX_LEFT $BBOX_RIGHT $BBOX_TOP $BBOX_BOTTOM
    # exit
    $osmosis --read-pbf /home/maps/$RELATION_NAME.osm.pbf --bounding-box left=$BBOX_LEFT right=$BBOX_RIGHT top=$BBOX_TOP bottom=$BBOX_BOTTOM --log-progress --write-pgsimp-dump directory=/home/maps/$OSM_ID/ enableBboxBuilder=yes enableLinestringBuilder=yes
else
    echo "Estenzione della mappa invalida: $MAP_TYPE"
fi



# rm /home/maps/$OSM_ID.osm
cd /home/maps/$OSM_ID/
psql postgresql://admin:admin@postgres:5432/maps -f /home/maps/$OSM_ID/pgsimple_load_0.6.sql
cd /home/scripts/
psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/performance_optimization.sql -v OSM_ID=$OSM_ID

