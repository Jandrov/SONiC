FROM ubuntu:latest
RUN apt-get install -y update \
    net-tools
    
FROM docker-sonic-p4:latest
RUN apt-get install -y update \
    net-tools
