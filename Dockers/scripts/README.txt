Istruzioni per triplificazione : 
    -copiare sparqlify (della VM) in Dockers/scripts/tools/
    -copiare centro-latest.osm.pbf in Dockers/maps/
    -fare il compose up dei docker
    -collegarsi al container di postgres
    -eseguire i seguenti comandi: 
        -apt-get update
        -apt-get install --no-install-recommends -y postgresql-9.6-postgis-2.3 postgresql-9.6-postgis-2.3-scripts
        -apt-get clean 
        -rm -rf /var/lib/apt/lists/*
    -collegarsi al container con ubuntu
    -eseguire nella cartella /home/scripts in ordine:
        -install_osmosis.sh
        -init.sh
    Scegliere se eseguire la versione nuova o quella vecchia
    [vecchia versione] entrare in old_version ed eseguire in ordine:
        -load_map.sh
        -triplify.sh
    [nuova versione] entrare in new_version ed eseguire in ordine:
        -load_mapV2.sh
        -irdbcmap.sh
