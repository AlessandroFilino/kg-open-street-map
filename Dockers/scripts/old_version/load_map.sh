#!/bin/sh
osmosis=/home/scripts/tools/osmosis/bin/osmosis
$osmosis --read-pbf /home/maps/centro-latest.osm.pbf --log-progress --write-pgsimp-dump directory=/home/maps/centro-latest/ enableBboxBuilder=yes enableLinestringBuilder=yes
cd /home/maps/centro-latest/
psql postgresql://admin:admin@postgres:5432/maps -f pgsimple_load_0.6.sql
cd /home/scripts/old_version/
psql postgresql://admin:admin@postgres:5432/maps -v boundary=41977 -f /home/scripts/old_version/init.sql
