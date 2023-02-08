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

# Compare the map that is stored in your Postgresql database with the most up-to-date version of the same map that is available on geofabrick, and apply changes to your local map

osmosis --read-pgsimp database=europe_italy_centro_osm user=europe_italy_centro_osm_usr password=europe_italy_centro_osm_psw --dataset-dump --write-pbf
osmosis --read-pbf file=dump.osm.pbf --sort --write-pbf file=sorted-dump.osm.pbf
wget http://download.geofabrik.de/europe/italy/centro-latest.osm.pbf
osmosis --read-pbf file=centro-latest.osm.pbf --sort --write-pbf file=sorted-centro-latest.osm.pbf
osmosis --read-pbf file=sorted-centro-latest.osm.pbf --read-pbf file=sorted-dump.osm.pbf --derive-change --write-xml-change
osmosis --read-xml-change --write-pgsimp-change database=europe_italy_centro_osm user=europe_italy_centro_osm_usr password=europe_italy_centro_osm_psw
psql -h localhost -U europe_italy_centro_osm_usr -d europe_italy_centro_osm -f update.sql
rm centro-latest.osm.pbf change.osc dump.osm.pbf sorted-centro-latest.osm.pbf sorted-dump.osm.pbf
