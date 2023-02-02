#comandi per connettersi al database sul container : "postgres"
#psql postgresql://user:psw@ip:port/db_name
#psql postgresql://admin:admin@postgres:5432/admin


CLEAN_INIT=false 

#installazione e compilazione di sparqlify da src
if [ "$CLEAN_INIT" = true ] || [ ! -d "/home/sparqlify" ];
then 
    rm -fr /home/sparqlify
    git clone https://github.com/SmartDataAnalytics/Sparqlify /home/sparqlify
    cp -fr ./Main.java /home/sparqlify/sparqlify-cli/src/main/java/org/aksw/sparqlify/web/Main.java
fi

cd /home/sparqlify
mvn clean install

cd sparqlify-cli
mvn assembly:assembly

#osmosis --read-apidb database="map" user="admin" password="admin" --write-xml file="./../map/florence-partial.osm"





# comando che genera errore e tiene aperto il container dopo il compose up
# tail -F anything 
