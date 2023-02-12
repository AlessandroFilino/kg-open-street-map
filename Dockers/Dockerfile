FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

ADD ./scripts /home/scripts
WORKDIR /home

RUN apt-get update && apt-get install -y
RUN apt-get install postgresql -y
RUN apt-get install openjdk-8-jdk -y
RUN apt-get install wget -y
# RUN apt-get install git -y
# RUN apt-get install maven -y
# RUN mkdir ./osmosis
# RUN wget -P ./osmosis https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz 
# RUN tar xvfz ./osmosis/osmosis-0.48.3.tgz -C ./osmosis
# RUN rm ./osmosis/osmosis-0.48.3.tgz
# RUN chmod a+x ./osmosis/bin/osmosis
# RUN git clone https://github.com/SmartDataAnalytics/Sparqlify ./sparqlify
# RUN cp -fr ./scripts/Main.java ./sparqlify/sparqlify-cli/src/main/java/org/aksw/sparqlify/web/Main.java
# RUN (cd ./sparqlify && mvn clean install) || true
# RUN (cd ./sparqlify/sparqlify-cli && mvn assembly:assembly) || true
