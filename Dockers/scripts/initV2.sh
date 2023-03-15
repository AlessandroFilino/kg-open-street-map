#SCRIPT PER PREPARARE IL DATABASA CON CARATTERISTICHE DA simple_schema

#!/bin/sh
chmod -R 777 /home/

if [ ! -d "/home/scripts/tools/" ];
    then
        mkdir /home/scripts/tools/
    fi

cd /home/scripts/tools/

if [ ! -d "./osmosis" ];
    then
        mkdir -p ./osmosis
        wget -P ./osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
        tar xvfz ./osmosis/osmosis-0.48.3.tgz -C ./osmosis
        rm ./osmosis/osmosis-0.48.3.tgz
        chmod a+x ./osmosis/bin/osmosis
    fi

if [ ! -d "./sparqlify" ];
    then
        unzip /home/scripts/sparqlify.zip -d ./
    fi

cd /home/scripts/




psql postgresql://admin:admin@postgres:5432/admin -c 'DROP DATABASE maps_custom;'
psql postgresql://admin:admin@postgres:5432/admin -c 'CREATE DATABASE maps_custom;'
psql postgresql://admin:admin@postgres:5432/maps_custom -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'

psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://admin:admin@postgres:5432/maps_custom -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql