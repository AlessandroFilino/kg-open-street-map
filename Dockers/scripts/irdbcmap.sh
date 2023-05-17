#!/bin/sh

OSM_ID=$1
RELATION_NAME=$2
GENERATE_OLD=$3

if [ $GENERATE_OLD = "True" ]; then
    psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/irdbcmap_old.sql -v OSM_ID=$OSM_ID
    /home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/$OSM_ID/"$OSM_ID"_old.drt
    cd /home/maps/$OSM_ID/
    tail -n +3 "$OSM_ID"_old.drt > "$OSM_ID"_old.cln 
    sort "$OSM_ID"_old.cln | uniq > "$OSM_ID"_old.n3 
    rm "$OSM_ID"_old.drt "$OSM_ID"_old.cln
fi

psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/irdbcmap.sql -v OSM_ID=$OSM_ID
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/$OSM_ID/$OSM_ID.drt
cd /home/maps/$OSM_ID/
tail -n +3 $OSM_ID.drt > $OSM_ID.cln 
sort $OSM_ID.cln | uniq > $OSM_ID.n3 
rm $OSM_ID.drt $OSM_ID.cln
