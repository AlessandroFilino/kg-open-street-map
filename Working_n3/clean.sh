#!/bin/bash

grep '201906809' ./../Dockers/maps/tmp/*.n3 > extract.txt

echo > cleaned.txt

while read line;
    do
        cleaned=${line//'<http://www.disit.org/km4city/resource/OS00098463511RE/'/}
        cleaned=${cleaned//'<*schema'/}
        echo $cleaned >> cleaned.txt
        if [[ "$cleaned" == *"#RoadElement>"* ]];
        then
            echo -e "\n" >> cleaned.txt
        fi
        
    done < extract.txt