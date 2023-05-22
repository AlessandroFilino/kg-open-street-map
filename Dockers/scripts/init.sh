#!/bin/sh

DB_USER="admin"
DB_NAME="maps"
DB_PASSWORD="admin"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" ||
  { echo "Errore durante l'esecuzione del comando psql: Eliminazione del database"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "CREATE DATABASE $DB_NAME;" ||
  { echo "Errore durante l'esecuzione del comando psql: Creazione del database"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore;" ||
  { echo "Errore durante l'esecuzione del comando psql: Creazione delle estensioni"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema delle azioni"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema delle bounding box"; exit 1; }

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql ||
  { echo "Errore durante l'esecuzione del comando psql: Importazione dello schema dei linestring"; exit 1; }

exit 0
