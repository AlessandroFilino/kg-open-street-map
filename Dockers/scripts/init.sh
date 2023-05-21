#!/bin/sh

DB_USER="admin"
DB_NAME="maps"
DB_PASSWORD="admin"

check_error() {
    if [ $1 -ne 0 ]; then
        echo "Errore durante l'esecuzione del comando psql: $2"
        exit 1 
    fi
}

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
check_error $? "Eliminazione del database"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/postgres -c "CREATE DATABASE $DB_NAME;"
check_error $? "Creazione del database"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore;"
check_error $? "Creazione delle estensioni"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6.sql
check_error $? "Importazione dello schema"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_action.sql
check_error $? "Importazione dello schema delle azioni"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_bbox.sql
check_error $? "Importazione dello schema delle bounding box"

psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/$DB_NAME -f /home/scripts/tools/osmosis/script/pgsimple_schema_0.6_linestring.sql
check_error $? "Importazione dello schema dei linestring"

exit 0
