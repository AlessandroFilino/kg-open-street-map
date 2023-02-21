#!/bin/sh

psql postgresql://admin:admin@postgres:5432/maps_custom  -f /home/scripts/irdbcmapV2.sql
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps_custom -U admin -W admin -o ntriples --dump > /home/maps/tmp/42621_V2.drt
cd /home/maps/tmp/
tail -n +3 42621_V2.drt > 42621_V2.cln 
sort 42621_V2.cln | uniq > 42621_V2.n3 
rm 42621_V2.drt 42621_V2.cln