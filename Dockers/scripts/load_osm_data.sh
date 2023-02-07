#!/bin/bash

#sintassi per connettersi senza password in prompt
#psql postgresql://user:psw@ip:port/db_name

#si connetta al container postgres con utente admin e crea un database per contenere osm data
psql postgresql://admin:admin@postgres:5432/admin -c 'CREATE DATABASE IF NOT EXISTS maps;'

psql postgresql://admin:admin@postgres:5432/maps -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'
psql postgresql://admin:admin@postgres:5432/maps -f /home/osmosis/script/pgsimple_schema_0.6.sql

osmosis --read-pbf /home/maps/centro-latest.osm.pbf --log-progress --write-pgsimp host=postgres database=maps user=admin password=admin