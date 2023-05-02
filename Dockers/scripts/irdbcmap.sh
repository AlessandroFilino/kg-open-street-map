#!/bin/sh

OSM_ID=$1
RELATION_NAME=$2

psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/irdbcmap.sql -v OSM_ID=$OSM_ID
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/$OSM_ID/$OSM_ID.drt
cd /home/maps/$OSM_ID/
tail -n +3 $OSM_ID.drt > $OSM_ID.cln 
sort $OSM_ID.cln | uniq > $OSM_ID.n3 
rm $OSM_ID.drt $OSM_ID.cln