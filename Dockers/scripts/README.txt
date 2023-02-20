Requisiti:
    -centro-latest.osm.pbf presente in /Dockers/maps/
    -sparqlify.zip presente in /Dockers/scripts/

Mappe disponibili per la triplificazione : centro-latest(da geofrabik) 
per cambiare:
    -aggiungere mappa.pbf in maps 
    -creare una cartella in /maps/mappa_da_aggiungere
    -aggiornare le directory in load_map.sh

Caso specifico : Firenze (OSM_ID : 42602)
per cambiare:
    -modificare l'OSM_ID in irdbcmap.sql


Istruzioni per triplificazione : 
    -fare il compose up dei docker
    -collegarsi ad una shell del container con ubuntu
    -eseguire nella cartella /home/scripts in ordine:
        -init.sh
        -load_map.sh
        -irdbcmap.sh
