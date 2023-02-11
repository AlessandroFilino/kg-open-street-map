#SCRIPT PER PREPARARE IL DATABASA CON CARATTERISTICHE DA simple_schema

#!/bin/sh

chmod -R 777 /home/scripts/
chmod -R 777 /home/maps/

psql postgresql://admin:admin@postgres:5432/admin -c 'DROP DATABASE maps;'
psql postgresql://admin:admin@postgres:5432/admin -c 'CREATE DATABASE maps;'
psql postgresql://admin:admin@postgres:5432/maps -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'

psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql