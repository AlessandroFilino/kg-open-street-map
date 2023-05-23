#!/bin/sh

DB_USER="admin"
DB_PASSWORD="admin"
DB_NAME="maps"
osmosis="/home/scripts/tools/osmosis/bin/osmosis"

OSM_ID=$1
RELATION_NAME=$2
MAP_TYPE=$3
BBOX_LEFT=$6
BBOX_RIGHT=$7
BBOX_TOP=$5
BBOX_BOTTOM=$4

# Creazione o rimozione della mappa se già presente
if [ ! -d /home/maps/$OSM_ID ]; then
    mkdir /home/maps/$OSM_ID
else
    rm -r /home/maps/$OSM_ID
    mkdir /home/maps/$OSM_ID
fi

cp /home/scripts/pgsimple_load_0.6.sql /home/maps/$OSM_ID ||
  { echo "Errore durante la copia di /home/scripts/pgsimple_load_0.6.sql in /home/maps/$OSM_ID"; exit 1; }


# Si esegue il dump dei dati della mappa in file .txt
# Se la mappa è fornita dall'utente (pbf) prima di eseguire il dump viene eseguito un filtro sull'bbox di interesse
if [ $MAP_TYPE = "osm" ]; then
    $osmosis --read-xml  /home/maps/$OSM_ID.osm --log-progress --write-pgsimp-dump directory=/home/maps/$OSM_ID/ enableBboxBuilder=yes enableLinestringBuilder=yes ||
  { echo "Errore durante la lettura di /home/maps/$OSM_ID.osm con osmosis"; exit 1; } 
elif [ $MAP_TYPE = "pbf" ]; then
    # Filtriamo la mappa in base al bbox di interesse
    $osmosis --read-pbf /home/maps/$RELATION_NAME.osm.pbf --bounding-box left=$BBOX_LEFT right=$BBOX_RIGHT top=$BBOX_TOP bottom=$BBOX_BOTTOM --log-progress --write-pgsimp-dump directory=/home/maps/$OSM_ID/ enableBboxBuilder=yes enableLinestringBuilder=yes ||
  { echo "Errore durante la lettura di /home/maps/$OSM_ID.pbf con osmosis"; exit 1; } 
else
   { echo "Estenzione dell mappa non valida"; exit 1; } 
fi

# Si effettua il caricamento dei dump sul database e l'ottimizzazione
cd /home/maps/$OSM_ID/
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/maps/$OSM_ID/pgsimple_load_0.6.sql ||
  { echo "Errore durante il load della mappa con /home/maps/$OSM_ID/pgsimple_load_0.6.sql"; exit 1; } 
cd /home/scripts/
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/performance_optimization.sql -v OSM_ID=$OSM_ID ||
  { echo "Errore durante l'esecuzione di /home/scripts/performance_optimization.sql sul db"; exit 1; } 
