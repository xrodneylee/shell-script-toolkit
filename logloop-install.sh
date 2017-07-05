#!/bin/sh
# author : guanpu.lee

chmod 777 logloop-install-linux64-latest.bin
./logloop-install-linux64-latest.bin -plogloop@201706
cd logloop-install
./install-docker.sh
./install.sh
sudo systemctl start logloop