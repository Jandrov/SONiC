FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    net-tools
    
FROM docker-sonic-p4
RUN apt-get update && apt-get install -y \
    net-tools
