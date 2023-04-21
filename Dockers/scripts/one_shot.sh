#!/bin/sh

OSM_ID=$1
RELATION_NAME=$2

./init.sh
./load_map.sh montemignaio
./irdbcmap.sh 42621 montemignaio