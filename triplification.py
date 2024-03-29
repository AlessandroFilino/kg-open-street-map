#!/usr/bin/env python3

# Es di run 
# python3 triplification.py -r montemignaio -l http://example.org/test1
import argparse
import requests
import os
import shutil
import subprocess
import pathlib
import time
import sys

def parse_arguments():
    parser = argparse.ArgumentParser(prog="OneShotScript",
                                 description="A partire da un estratto OSM, genera triple in formato .n3 da poter caricare su virtuoso rdf store",
                                 formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument("-f", "--file_name",
                        help="Copiare la mappa in formato .pbf in /Dockers/maps/",
                        nargs=1,
                        type=str)
    
    parser.add_argument("-r", "--relation_name",
                        help="Inserire il nome della relazione su cui si vuole compiere la triplificazione, per sceglier un osm_id specifico usare invevce --OSM_ID. \n\
    Se FILE_NAME non è specificato la mappa verrà scaricata automaticamente tramite geofabrik.",
                        nargs=1,
                        type=str)
    
    parser.add_argument("-o", "--osm_id",
                        help="Inserire l'OSM_ID della relazione su cui si vuole compiere la triplificazione. \n\
    Se FILE_NAME non è specificato la mappa verrà scaricata automaticamente tramite overpass.",
                        nargs=1,
                        type=str)
    
    parser.add_argument("-l", "--load_to_rdf",
                        metavar="GRAPH_NAME",
                        help="Carica automaticamente le triple generate su virtuoso rdf store nel grafo indicato",
                        nargs=1,
                        type=str)
    
    parser.add_argument("--generate_old",
                        action="store_true",
                        help="Genera anche un altro file .n3 contenente le triple senza filtri (con tutti i road element intermedi)")

    args = parser.parse_args()


    if not (args.relation_name or args.osm_id):
        parser.error("Nessuna azione da compiere, specificare RELATION_NAME o OSM_ID")
    elif args.relation_name and args.osm_id:
        parser.error("RELATION_NAME e OSM_ID specificati, scegliere solo una delle due opzioni")


    return vars(args)
    
def get_relation_data_by_name(relation_name):
    json = requests.get(f"https://nominatim.openstreetmap.org/search.php?q={relation_name}&format=json").json()
    #filtro per estrarre la relazione
    for osm_element in json:
        if (osm_element["osm_type"] == "relation" and osm_element["class"] == "boundary"):
            relation_data = osm_element
            return relation_data

def get_relation_data_by_osmid(osm_id):
    response = requests.get(f"https://nominatim.openstreetmap.org/lookup?osm_ids=R{osm_id}&format=json").json()
    relation_data = response[0]
    if relation_data["osm_type"] != "relation":
        print(f"Errore l'osm_id : {osm_id} non corrisponde ad una relazione")
        exit(-1)
    elif relation_data["class"] != "boundary":
        print(f"Errore l'osm_id : {osm_id} non corrisponde ad un boundary")
        exit(-1)

    return relation_data
    

def download_map(osm_id, bbox):
   
    boundingbox = bbox
    for coord_idx in range(4):
        boundingbox[coord_idx] = float(boundingbox[coord_idx])
    
    #verifico che non esistano già dati relativi a questa relazione
    if os.path.exists(f"{BASE_DIR}/Dockers/maps/{osm_id}.osm"):
        print(f"{osm_id}.osm già presente, la mappa non verrà riscaricata")
        return osm_id


    query=(f"[out:xml];"
           f"(node({boundingbox[0]},{boundingbox[2]},{boundingbox[1]},{boundingbox[3]});"
           f"way({boundingbox[0]},{boundingbox[2]},{boundingbox[1]},{boundingbox[3]});"
           f"relation({boundingbox[0]},{boundingbox[2]},{boundingbox[1]},{boundingbox[3]});"
           f"<;);out%20center%20meta;")
    
    print(f"Sto scaricando i dati relativi a {osm_id} da open-street-map, attendere")
    
    with open(f"{BASE_DIR}/Dockers/maps/{osm_id}.osm", "wb+") as f:
        map_data = requests.get(f"http://overpass-api.de/api/interpreter?data={query}", stream=True)
        for data in map_data.iter_content(1024):
            f.write(data)

    print("Mappa scaricata con successo")

def execute_shell_command(command, log_output=None, handle_exit_number=False):

    if handle_exit_number==False:
        process = subprocess.Popen(command, stdout=subprocess.PIPE)
    else:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    while process.poll() is None:
        while True:
            line = process.stdout.readline()
            if not line: break
            if log_output != None:
                log_output.append(line.decode())
            else:
                print(line.decode())

    if process.returncode != 0 and handle_exit_number:
        print(f"Errore durante l'esecuzione del comando: {command}. Codice di uscita: {process.returncode}")
        sys.exit(1)


BASE_DIR = pathlib.Path(__file__).parent.resolve()

def main():
    # Recupero delle opzioni con il parsing
    args = parse_arguments()
    relation_name = None
    file_name = args["file_name"]
    generate_old = args["generate_old"]
    graph_name = None
    osm_id = args["osm_id"]
    map_type = None
    bbox = [0, 0, 0, 0]
    

    if args["load_to_rdf"] != None:
        graph_name = args["load_to_rdf"][0]

    if args["relation_name"] != None:
        relation_name = args["relation_name"][0]

    # Recupero della bbox della mappa tramite osm_id o relation_name, 
    # nel secondo caso viene dedotto anche l'osm_id basandosi sulla relazione più importante con quel nome
    if relation_name != None:
        relation_data = get_relation_data_by_name(relation_name)
        osm_id = relation_data["osm_id"]
    elif osm_id != None:
        osm_id = osm_id[0]
        relation_data = get_relation_data_by_osmid(osm_id)
    bbox = relation_data["boundingbox"]

    # Se file_name è specificato si verifica che la mappa esista
    if file_name != None:
        file_name = file_name[0]
        map_type = "pbf"

        if not os.path.exists(f"{BASE_DIR}/Dockers/maps/{file_name}"):
            print(f"Impossibile trovare la mappa in {BASE_DIR}/Dockers/maps/{file_name}")
            exit(-1)
    # Se non è specificato file_name la mappa viene scaricata automaticamente
    else:
        download_map(osm_id, bbox)
        file_name = f"{osm_id}.osm"
        map_type = "osm"

    # Avviamo i container e attendiamo che postgres sia inizializzato e pronto a ricevere connessioni
    inizialization_postgres = False
    os.chdir(f"{BASE_DIR}/Dockers")

    if not os.path.exists(f"{BASE_DIR}/Dockers/postgresDB"):
        inizialization_postgres = True

    execute_shell_command(["docker", "compose", "up", "-d"])

    timeout = -1
    ready_to_accept_conn = False
    while not ready_to_accept_conn:
        time.sleep(1)
        timeout += 1
        if (timeout > 60):
            print("Errore container postgres non è pronto a ricevere connessioni. (TIMEOUT: 60 s)")
            return    
        
        isReady = []
        execute_shell_command(["docker", "exec", "-it", "kg-open-street-map-postgres-1", "pg_isready" ], log_output=isReady)
        for line in isReady:
            if line.find("accepting connections") != -1:
                if(inizialization_postgres):
                   print("Inizializzazione di postgress")
                   time.sleep(40)
                   inizialization_postgres = False   
                print("Container postgress avviato correttamente")
                ready_to_accept_conn = True
                break
    # Effettuiamo l'inizializazione del database su postgres rendendolo pronto a ricevere i dati postgis
    execute_shell_command(["docker", "exec", "-it", "kg-open-street-map-ubuntu-1", "sh", "-c", "/home/scripts/init.sh"], handle_exit_number=True)
    # Effettuiamo il load della mappa e l'ottimizzazione del db
    file_name_cleaned = file_name.split(".")[0]
    execute_shell_command(["docker", "exec", "-it", "kg-open-street-map-ubuntu-1", "sh", "-c", f"/home/scripts/load_map.sh {osm_id} {file_name_cleaned} {map_type} {float(bbox[0])} {float(bbox[1])} {float(bbox[2])} {float(bbox[3])}"], handle_exit_number=True)
    # Eseguiamo una serie di query sul db e la triplificazione 
    execute_shell_command(["docker", "exec", "-it", "kg-open-street-map-ubuntu-1", "sh", "-c", f"/home/scripts/irdbcmap.sh {osm_id} {file_name_cleaned} {generate_old}"], handle_exit_number=True)

    # Se è specificato un grafo , le triple verrano caricate direttamente su di esso nel container con virtuoso rdf store
    if graph_name != None:
        path_in_virtuoso = f"{BASE_DIR}/Dockers/virtuoso_data/{osm_id}" 
        if os.path.exists(path_in_virtuoso):
            for triple in os.listdir(path_in_virtuoso):
                os.remove(path_in_virtuoso + "/" + triple)
            os.rmdir(path_in_virtuoso)

        os.mkdir(path_in_virtuoso)
        shutil.copy2(f"{BASE_DIR}/Dockers/maps/{osm_id}/{osm_id}.n3", path_in_virtuoso)
        execute_shell_command(["docker", "exec", "-it", "kg-open-street-map-ubuntu-1", "sh", "-c", f"/home/scripts/load_to_virtuoso.sh {osm_id} {graph_name}"])

if __name__ == "__main__":
    main()