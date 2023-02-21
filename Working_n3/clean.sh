#!/bin/bash

grep '201906809' ./../Dockers/maps/tmp/*.n3 > extract.txt

grep '201906801' ./../Dockers/maps/tmp/*.n3 > extract2.txt


echo > cleaned.txt

echo > cleaned2.txt

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

while read line;
    do
        cleaned=${line//'<http://www.disit.org/km4city/resource/OS00098463511RE/'/}
        cleaned=${cleaned//'<*schema'/}
        echo $cleaned >> cleaned2.txt
        if [[ "$cleaned" == *"#RoadElement>"* ]];
        then
            echo -e "\n" >> cleaned2.txt
        fi
        
    done < extract2.txt