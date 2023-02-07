FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

ADD ./scripts /home/scripts

RUN apt-get update && apt-get install -y
RUN apt-get install wget -y
RUN apt-get install postgresql -y
RUN apt-get install git -y
RUN apt-get install maven -y
RUN /home/scripts/init.sh
