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

# Create a new Postgresql database and user, and first load the extract of the Open Street Map of your interest to the newly created database

psql -c "CREATE USER europe_italy_centro_osm_usr WITH PASSWORD 'europe_italy_centro_osm_psw';" 
createdb -O europe_italy_centro_osm_usr europe_italy_centro_osm
psql -d europe_italy_centro_osm -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -f /usr/share/doc/osmosis/examples/pgsimple_schema_0.6.sql
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -f /usr/share/doc/osmosis/examples/pgsimple_schema_0.6_action.sql
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -f /usr/share/doc/osmosis/examples/pgsimple_schema_0.6_bbox.sql
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -f /usr/share/doc/osmosis/examples/pgsimple_schema_0.6_linestring.sql
wget http://download.geofabrik.de/europe/italy/centro-latest.osm.pbf
osmosis --read-pbf centro-latest.osm.pbf --log-progress --write-pgsimp database=europe_italy_centro_osm user=europe_italy_centro_osm_usr password=europe_italy_centro_osm_psw
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -v boundary=41977 -f init.sql
rm centro-latest.osm.pbf
