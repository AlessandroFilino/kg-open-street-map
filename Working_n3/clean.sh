#!/bin/bash

road_id='201906809'

grep $road_id ./../Dockers/maps/montemignaio/42621.n3 > $road_id.txt


echo > "$road_id"_cleaned.txt

python3 ./clean.py $road_id
