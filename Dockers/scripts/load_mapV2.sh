#!/bin/sh
osmosis=/home/scripts/tools/osmosis/bin/osmosis
$osmosis --read-xml  /home/maps/montemignaio.osm --log-progress --write-pgsimp-dump directory=/home/maps/tmp/ enableBboxBuilder=yes enableLinestringBuilder=yes
cd /home/maps/tmp/
psql postgresql://admin:admin@postgres:5432/maps -f pgsimple_load_0.6.sql
cd /home/scripts/
psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/performance_optimization.sql
