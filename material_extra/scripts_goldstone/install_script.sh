#!/bin/bash

cd ~
if [ ! -d "environment" ]; then
	mkdir environment
fi
export K="sudo k3s kubectl"
~/TFGs/script1.sh
~/TFGs/script2.sh
~/TFGs/script3.sh
