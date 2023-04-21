#!/bin/sh
osmosis=/home/scripts/tools/osmosis/bin/osmosis
RELATION_NAME=$1

$osmosis --read-xml  /home/maps/$RELATION_NAME.osm --log-progress --write-pgsimp-dump directory=/home/maps/$RELATION_NAME/ enableBboxBuilder=yes enableLinestringBuilder=yes
cd /home/maps/$RELATION_NAME/
psql postgresql://admin:admin@postgres:5432/maps -f pgsimple_load_0.6.sql
cd /home/scripts/
psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/performance_optimization.sql

