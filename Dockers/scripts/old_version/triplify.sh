#!/bin/sh

psql postgresql://admin:admin@postgres:5432/maps -v boundary=42602 -f /home/scripts/old_version/triplify.sql
/home/scripts/sparqlify.sh -m /home/scripts/old_version/triplify.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/scripts/old_version/42602.drt
cd /home/scripts/old_version/
tail -n +3 42602.drt > 42602.cln 
sort 42602.cln | uniq > 42602.n3 
rm 42602.drt 42602.cln