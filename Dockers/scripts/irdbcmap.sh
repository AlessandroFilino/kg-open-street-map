#!/bin/sh

psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/irdbcmap.sql
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/centro-latest/42602.drt
cd /home/maps/centro-latest/
tail -n +3 42602.drt > 42602.cln 
sort 42602.cln | uniq > 42602.n3 
rm 42602.drt 42602.cln