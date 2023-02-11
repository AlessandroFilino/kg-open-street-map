#SCRIPT PER PREPARARE IL DATABASA CON CARATTERISTICHE DA simple_schema

#!/bin/sh
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
psql postgresql://admin:admin@postgres:5432/maps -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql