#!/bin/sh

# Definisci le variabili globali
DB_USER="admin"
DB_NAME="maps"
DB_PASSWORD="admin"

if [ ! -d /home/scripts/tools/osmosis ]; then
    mkdir -p /home/scripts/tools/osmosis
    wget -P /home/scripts/tools/osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
    tar xvfz /home/scripts/tools/osmosis/osmosis-0.48.3.tgz -C /home/scripts/tools/osmosis
    rm /home/scripts/tools/osmosis/osmosis-0.48.3.tgz
    chmod a+x /home/scripts/tools/osmosis/bin/osmosis      
fi

if [ ! -d /home/scripts/tools/sparqlify ]; then
    unzip /home/scripts/sparqlify.zip -d /home/scripts/tools/
fi

chmod -R 777 /home/scripts/
chmod -R 777 /home/maps/

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "CREATE DATABASE $DB_NAME;"
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore;"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql
