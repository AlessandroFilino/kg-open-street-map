#!/bin/bash

# var="<http://www.disit.org/km4city/schema#endsAtNode>"
# echo "${var//<*schema/}"


while read line;
    do
        cleaned=${line##<http://www.disit.org/km4city/resource/OS00098463511RE/}
        cleaned=${cleaned//<*schema/}
        echo $cleaned >> cleaned.txt
    done < extract.txt