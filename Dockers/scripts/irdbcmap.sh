#!/bin/sh

psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/irdbcmap.sql 
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/montemignaio/42621.drt
cd /home/maps/montemignaio/
tail -n +3 42621.drt > 42621.cln 
sort 42621.cln | uniq > 42621.n3 
rm 42621.drt 42621.cln