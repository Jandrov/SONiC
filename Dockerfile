FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install net-tools
RUN apt-get -y iputils-ping
