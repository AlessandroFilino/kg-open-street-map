Eseguendo oneshot_scriptV2.sh viene eseguito il setup e la triplificazione automaticamente, 
Una volta terminato, il processo dovrebbe generare un file (42602_V2.n3) contenente le triple in kg-open-street-map-release/Dockers/maps/montignano/.
La mappa è stata scelta in modo tale da permettere il caricamento sul database e la successiva triplificazione in tempi molto brevi (pochi minuti compreso il setup iniziale).

in alternativa i passi da compiere manualmente sono:

    -1) Eseguire il docker compose up con la configurazione kg-open-street-map-release/Dockers/docker-compose.yml 
    -2) Collegare una shell al container con ubuntu (kg-open-street-map-ubuntu-1)
    -3) Spostarsi in /home/scripts
    -4) Eseguire i seguenti scripts in ordine :
        -a) initV2.sh
        -b) load_mapV2.sh
        -c) irdbcmapV2.sh
    


Il file .n3 può essere caricato sul container contenente virtuoso (ACCOUNT : dba ; PSW : admin) tramite interfaccia browser (http://localhost:8890/) o con isql.

Per accedere al database è presente un container contenente pgadmin, il setup è il seguente:
        
    -1) Da terminale ricavare l'IPAddress del container postgres tramite il comando  "docker inspect kg-open-street-map-postgres-1"
    -2) Caricare l'interfaccia web all'indirizzo : localhost:5050 con credenziali email : test@gmail.com e psw : admin
    -3) Creare una connessione al server (Server -> create -> Server) con un nome qualsiasi ed utilizzando i seguenti parametri in connection : 
        -Hostname : IPAddress ricavato al punto 1
        -Maintenance database : maps_custom
        -Username : admin
        -psw : admin
        -port : lasciare default (5432)