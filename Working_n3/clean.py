import sys
import re

file_path = f"./{sys.argv[1]}.txt"
with open(file_path,"r") as f:
    extract = f.readlines()

with open(f"./{sys.argv[1]}_cleaned.txt","w") as f:
    for line in extract:
        cleaned = re.sub("<http://www.disit.org/km4city/resource/OS00201906809RE/", "", line)
        cleaned = re.sub(">.*schema#", " ", cleaned)

        f.write(cleaned)
        if cleaned.find("RoadElement") > 0:
            f.write("\n")
        