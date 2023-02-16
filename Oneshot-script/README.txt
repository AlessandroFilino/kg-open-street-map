Eseguendo oneshot_script.sh viene eseguito il setup e la triplificazione automaticamente,
in alternativa i passi da compiere sono:
    -1) Scaricare la release da (https://github.com/AlessandroFilino/kg-open-street-map/archive/refs/tags/v1.0.0.zip) e scompattare l'archivio

    -2) Scaricare sparqlify da (https://github.com/AlessandroFilino/kg-open-street-map/releases/download/v1.0.0/sparqlify.zip) e copiare l'archivio in 
    kg-open-street-map-1.0.0/Dockers/scripts/

    -3) Scaricare la mappa del centro italia da (https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf) e copiare il .pbf in 
    kg-open-street-map-1.0.0/Dockers/maps/

    -4) Eseguire il docker compose up con la configurazione kg-open-street-map-1.0.0/Dockers/docker-compose.yml 

    -5) Collegare una shell al container con ubuntu (kg-open-street-map-ubuntu-1) ed eseguire i seguenti scripts in ordine :
        -a) init.sh
        -b) load_map.sh
        -c) irdbcmap.sh
    
Una volta terminati, gli scripts dovrebbero generare un file (42602.n3) contenente le triple in kg-open-street-map-1.0.0/Dockers/maps/centro-latest/
Questo può essere caricato sul container contenente virtuoso (ACCOUNT dba PSW admin)