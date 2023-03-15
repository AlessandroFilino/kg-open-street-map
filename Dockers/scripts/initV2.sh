#SCRIPT PER PREPARARE IL DATABASA CON CARATTERISTICHE DA simple_schema

#!/bin/sh

if [ ! -d home/scripts/tools ];
    then
        mkdir -p ./tools/osmosis
        wget -P ./tools/osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
        tar xvfz ./tools/osmosis/osmosis-0.48.3.tgz -C ./tools/osmosis
        rm ./tools/osmosis/osmosis-0.48.3.tgz
        chmod a+x ./tools/osmosis/bin/osmosis
        unzip ./sparqlify.zip -d ./tools/
    fi


chmod -R 777 /home/scripts/
chmod -R 777 /home/maps/


psql postgresql://admin:admin@postgres:5432/admin -c 'DROP DATABASE maps_custom;'
psql postgresql://admin:admin@postgres:5432/admin -c 'CREATE DATABASE maps_custom;'
psql postgresql://admin:admin@postgres:5432/maps_custom -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'

psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql