#!/bin/sh
$osmosis --read-pbf /home/maps/centro-latest.osm.pbf --log-progress --write-pgsimp host=postgres database=maps user=admin password=admin
#PRIMA DI ESEGUIRE init.sql RICHIEDE CHMOD 777 su init.sql
chmod 777 /home/scripts/tools/scripts/init.sql
psql postgresql://admin:admin@postgres:5432/maps -v boundary=41977 -f /home/scripts/tools/scripts/init.sql
