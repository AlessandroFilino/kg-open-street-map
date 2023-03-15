#!/bin/sh
osmosis=/home/scripts/tools/osmosis/bin/osmosis

$osmosis --read-xml  /home/maps/montemignaio.osm --log-progress --write-pgsimp-dump directory=/home/maps/montemignaio/ enableBboxBuilder=yes enableLinestringBuilder=yes
cd /home/maps/montemignaio/
psql postgresql://admin:admin@postgres:5432/maps_custom -f pgsimple_load_0.6.sql
cd /home/scripts/
psql postgresql://admin:admin@postgres:5432/maps_custom  -f /home/scripts/performance_optimization.sql


