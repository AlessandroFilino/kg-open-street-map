#!/bin/sh

#  OSM2KM4C
#  Copyright (C) 2017 DISIT Lab http://www.disit.org - University of Florence
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Produce RDF triples   

#DARE CHMOD 777 A TRIPLIFY.SQL
psql postgresql://admin:admin@postgres:5432/maps -v boundary=42602 -f /home/scripts/tools/scripts/triplify.sql
cd /home/scripts/tools/scripts/
/home/scripts/tools/sparqlify/sparqlify.sh -m /home/scripts/tools/scripts/triplify.sml -h postgres -d maps -U admin -W admin -o ntriples --dump > /home/scripts/tools/scripts/42602.drt
cd /home/scripts/tools/scripts/
tail -n +3 42602.drt > 42602.cln 
sort 42602.cln | uniq > 42602.n3 
#rm 42602.drt 42602.cln