FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install net-tools
CMD bash

FROM docker-sonic-p4
RUN apt-get -y update
RUN apt-get -y install net-tools
CMD bash
