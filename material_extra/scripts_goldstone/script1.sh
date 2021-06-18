#!/bin/bash

cd ~/environment
git clone git@github.com:microsonic/goldstone-mgmt.git
git clone git@github.com:microsonic/usonic.git
cd goldstone-mgmt/
curl -sfL https://get.k3s.io | sh -s - --docker
git diff --compact-summary HEAD origin/master | (grep 'sm/\|patches/\|builder.Dockerfile' && make builder np2) || true
git submodule update --init --recursive
make docker
docker pull microsonic/gs-mgmt
docker pull microsonic/gs-mgmt-debug

sudo k3s kubectl create -f ./k8s
while [ true ]; do   sleep 10;   $K get pods || true;   ($K logs ds/gs-mgmt-cli | grep "modules") && exit 0|| true; done
