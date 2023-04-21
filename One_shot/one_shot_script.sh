#!/bin/sh

REGION_NAME=$(grep -Po '(?<=\[Region_Name\] : ")[^"]*' ./setup.config)
REGION_BOX=$(grep -Po '(?<=\[Region_Box\] : ")[^"]*' ./setup.config)

wget -O $REGION_NAME.osm "https://api.openstreetmap.org/api/0.6/map?bbox=$REGION_BOX"
