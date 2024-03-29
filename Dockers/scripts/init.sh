#!/bin/sh

DB_USER="admin"
DB_NAME="maps"
DB_PASSWORD="admin"

# Scarichiamo osmosis se non è presente
if [ ! -d /home/scripts/tools/osmosis ]; then
    mkdir -p /home/scripts/tools/osmosis
    wget -P /home/scripts/tools/osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
    tar xvfz /home/scripts/tools/osmosis/osmosis-0.48.3.tgz -C /home/scripts/tools/osmosis
    rm /home/scripts/tools/osmosis/osmosis-0.48.3.tgz
    chmod a+x /home/scripts/tools/osmosis/bin/osmosis      
fi
# Estraiamo sparqlify se non è presente
if [ ! -d /home/scripts/tools/sparqlify ]; then
    unzip /home/scripts/sparqlify.zip -d /home/scripts/tools/ ||
  { echo "Errore durante l'estrazione di /home/scripts/sparqlify.zip in /home/scripts/tools/"; exit 1; }
fi

chmod -R 777 /home/scripts/
chmod -R 777 /home/maps/

# Le seguente query creano un nuovo database (maps) e lo inizializzano per il caricamento della mappa con osmosis
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" ||
  { echo "Errore durante l'esecuzione del comando psql: Eliminazione del database"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "CREATE DATABASE $DB_NAME;" ||
  { echo "Errore durante l'esecuzione del comando psql: Creazione del database"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore;" ||
  { echo "Errore durante l'esecuzione del comando psql: Creazione delle estensioni"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema delle azioni"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema delle bounding box"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema dei linestring"; exit 1; }

exit 0
