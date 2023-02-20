#!/bin/sh

psql postgresql://admin:admin@postgres:5432/maps  -f /home/scripts/irdbcmap.sql
/home/scripts/sparqlify.sh -m /home/scripts/irdbcmap.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/maps/capraia/42288.drt
cd /home/maps/capraia/
# tail -n +3 42288.drt > 42288.cln 
# sort 42288.cln | uniq > 42288.n3 
# rm 42288.drt 42288.cln