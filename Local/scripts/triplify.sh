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

psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -v boundary=5918618129 -f triplify.sql
cd /home/debian/sparqlify ./sparqlify.sh -m 
/home/debian/samples/osm/triplify.sml -h localhost -d europe_italy_centro_osm -U 
europe_italy_centro_osm_usr -W europe_italy_centro_osm_psw -o ntriples --dump > 
/home/debian/samples/osm/42602.drt cd /home/debian/samples/osm tail -n +3 42602.drt > 
42602.cln sort 42602.cln | uniq > 42602.n3 rm 42602.drt 42602.cln
