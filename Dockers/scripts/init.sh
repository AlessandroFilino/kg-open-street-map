#!/bin/sh
#comandi per connettersi al database sul container : "postgres"
#psql postgresql://user:psw@ip:port/db_name
#psql postgresql://admin:admin@postgres:5432/admin


CLEAN_INIT=true 

#installazione e compilazione di sparqlify da src
if [ "$CLEAN_INIT" = true ] || [ ! -d "/home/sparqlify" ];
then 
    rm -fr /home/sparqlify
    git clone https://github.com/SmartDataAnalytics/Sparqlify /home/sparqlify
    cp -fr ./Main.java lssparqlify-cli/src/main/java/org/aksw/sparqlify/web/Main.java
fi

cd /home/sparqlify
mvn clean install

cd /home/sparqlify/sparqlify-cli
mvn assembly:assembly

java -cp /home/sparqlify/sparqlify-cli/target/sparqlify-cli-0.9.1-jar-with-dependencies.jar \
 RunEndpoint $@

#osmosis --read-apidb database="map" user="admin" password="admin" --write-xml file="./../map/florence-partial.osm"


# comando che genera errore e tiene aperto il container dopo il compose up
 tail -F anything 
