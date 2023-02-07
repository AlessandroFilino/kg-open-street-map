#!/bin/bash

cd ../scripts
mkdir -p ./tools
cd ./tools

CLEAN_INIT=false 

#setup osmosis
if [ "$CLEAN_INIT" = true ] || [ ! -d "./osmosis" ];
then 
    mkdir -p ./osmosis
    wget -P ./osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz
    tar xvfz ./osmosis/osmosis-0.48.3.tgz -C ./osmosis
    rm ./osmosis/osmosis-0.48.3.tgz
    chmod a+x ./osmosis/bin/osmosis
fi
#setup sparqlify
if [ "$CLEAN_INIT" = true ] || [ ! -d "./sparqlify" ];
then 
    git clone https://github.com/SmartDataAnalytics/Sparqlify ./sparqlify
    cp -fr ./../../setup/Main.java ./sparqlify/sparqlify-cli/src/main/java/org/aksw/sparqlify/web/Main.java
    cd ./sparqlify
    mvn clean install
    cd ./sparqlify-cli
    mvn assembly:assembly
fi
#setup osm2km4c sparqlify
if [ "$CLEAN_INIT" = true ] || [ ! -d "./sparqlify_scripts" ];
then 
    git clone https://github.com/disit/osm2km4c ./sparqlify_scripts/tmp
    cp -r ./sparqlify_scripts/tmp/sparqlify/* ./sparqlify_scripts
    chmod +w ./sparqlify_scripts/tmp
    rm -fr ./sparqlify_scripts/tmp 
fi

