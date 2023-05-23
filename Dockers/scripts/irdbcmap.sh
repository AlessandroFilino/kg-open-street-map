#!/bin/sh

DB_USER="admin"
DB_PASSWORD="admin"
DB_NAME="maps"

OSM_ID=$1
RELATION_NAME=$2
GENERATE_OLD=$3

if [ $GENERATE_OLD = "True" ]; then
    psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME  -f /home/scripts/irdbcmap_old.sql -v OSM_ID=$OSM_ID ||
  { echo "Errore durante l'esecuzione di /home/scripts/irdbcmap_old.sql sul db"; exit 1; } 
    /home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d $DB_NAME -U $DB_USER -W $DB_PASSWORD -o ntriples --dump > /home/maps/$OSM_ID/"$OSM_ID"_old.drt ||
  { echo "Errore durante l'esecuzione di /home/scripts/sparqlify.sh"; exit 1; } 
    cd /home/maps/$OSM_ID/
    tail -n +3 "$OSM_ID"_old.drt > "$OSM_ID"_old.cln 
    sort "$OSM_ID"_old.cln | uniq > "$OSM_ID"_old.n3 
    rm "$OSM_ID"_old.drt "$OSM_ID"_old.cln
fi

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME  -f /home/scripts/irdbcmap.sql -v OSM_ID=$OSM_ID ||
  { echo "Errore durante l'esecuzione di /home/scripts/irdbcmap_old.sql sul db"; exit 1; } 
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d $DB_NAME -U $DB_USER -W $DB_PASSWORD -o ntriples --dump > /home/maps/$OSM_ID/$OSM_ID.drt ||
  { echo "Errore durante l'esecuzione di /home/scripts/sparqlify.sh"; exit 1; } 
cd /home/maps/$OSM_ID/
tail -n +3 $OSM_ID.drt > $OSM_ID.cln 
sort $OSM_ID.cln | uniq > $OSM_ID.n3 
rm $OSM_ID.drt $OSM_ID.cln
