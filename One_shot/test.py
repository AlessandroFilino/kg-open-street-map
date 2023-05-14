#!/usr/bin/env python3
#execute_shell_command(["docker", "exec", "kg-open-street-map-virtuoso-1", "mkdir", "-p", f"/opt/virtuoso-opensource/database/42621/"])
#docker cp kg-open-street-map-ubuntu-1:/home/maps/42621/42621.n3 - | docker exec -i kg-open-street-map-virtuoso-1 tar x -C /opt/virtuoso-opensource/database/42621/

import subprocess

def execute_shell_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    return stdout.decode('utf-8').strip(), stderr.decode('utf-8').strip(), process.returncode

osm_id = 42621

# Esegue il comando completo utilizzando execute_shell_command
command = [
    "sh", "-c", f"docker cp kg-open-street-map-ubuntu-1:/home/maps/{osm_id}/{osm_id}.n3 - | docker exec -i kg-open-street-map-virtuoso-1 sh -c 'cd /opt/virtuoso-opensource/database/{osm_id}/ && tar x'"
]
stdout, stderr, returncode = execute_shell_command(command)
