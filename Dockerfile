FROM ubuntu:latest
RUN apt-get -y update \
    net-tools
    
FROM docker-sonic-p4:latest
RUN apt-get -y update \
    net-tools
