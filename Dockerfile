FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install net-tools
RUN apt-get -y ping

FROM docker-sonic-p4:latest
RUN apt-get -y update
RUN apt-get -y install net-tools
RUN apt-get -y ping
