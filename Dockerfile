ARG imagename
FROM $imagename
RUN apt-get update && apt-get install -y \
    net-tools

#FROM ubuntu:latest
#RUN apt-get update && apt-get install -y \
#    net-tools
    
#FROM docker-sonic-p4:latest
#RUN apt-get update && apt-get install -y \
#    net-tools
    

