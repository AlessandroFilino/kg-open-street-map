#!/bin/bash

road_id='201906809'

grep $road_id ./../Dockers/maps/tmp/42621_V2.n3 > $road_id.txt


echo > "$road_id"_cleaned.txt

python3 ./clean.py $road_id
