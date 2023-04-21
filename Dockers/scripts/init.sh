#SCRIPT PER PREPARARE IL DATABASA CON CARATTERISTICHE DA simple_schema

#!/bin/sh

if [ ! -d home/scripts/tools ];
    then
        mkdir -p home/scripts/tools/osmosis
        wget -P home/scripts/tools/osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
        tar xvfz home/scripts/tools/osmosis/osmosis-0.48.3.tgz -C home/scripts/tools/osmosis
        rm home/scripts/tools/osmosis/osmosis-0.48.3.tgz
        chmod a+x home/scripts/tools/osmosis/bin/osmosis
        unzip home/scripts/sparqlify.zip -d home/scripts/tools/
    fi


chmod -R 777 /home/scripts/
chmod -R 777 /home/maps/

psql postgresql://admin:admin@postgres:5432/admin -c 'DROP DATABASE maps;'
psql postgresql://admin:admin@postgres:5432/admin -c 'CREATE DATABASE maps;'
psql postgresql://admin:admin@postgres:5432/maps -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'

psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql

