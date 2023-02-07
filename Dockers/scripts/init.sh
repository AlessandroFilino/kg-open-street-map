#!/bin/bash
#comandi per connettersi al database sul container : "postgres"
#psql postgresql://user:psw@ip:port/db_name
#psql postgresql://admin:admin@postgres:5432/postgres


CLEAN_INIT=false 

#installazione e compilazione di sparqlify da src
if [ "$CLEAN_INIT" = true ] || [ ! -d "/home/sparqlify" ];
then 
    rm -fr /home/osmosis
    mkdir /home/osmosis
    cd /home/osmosis
    wget https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz
    tar xvfz /home/osmosis/osmosis-0.48.3.tgz
    rm /home/osmosis/osmosis-0.48.3.tgz
    chmod a+x bin/osmosis
    rm -fr /home/sparqlify
    git clone https://github.com/SmartDataAnalytics/Sparqlify /home/sparqlify
    cp -fr home/scripts/Main.java /home/sparqlify/sparqlify-cli/src/main/java/org/aksw/sparqlify/web/Main.java
    cd home/sparqlify
    mvn clean install 
    cd /home/sparqlify/sparqlify-cli
    mvn assembly:assembly || true
fi




