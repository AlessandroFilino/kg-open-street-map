
wget -P /home/scripts/tools/osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz
cd /home/scripts/tools/osmosis
tar xvfz /home/scripts/tools/osmosis/osmosis-0.48.3.tgz
rm /home/scripts/tools/osmosis/osmosis-0.48.3.tgz

chmod a+x /home/scripts/tools/osmosis/bin/osmosis
#QUESTO CI PERMETTE DI RICHIAMARE OSMOSIS CON $osmosis
osmosis=/home/scripts/tools/osmosis/bin/osmosis