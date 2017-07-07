#!/bin/sh
# author : guanpu.lee
sudo yum install -y docker-ce-17.06.0.ce-1.el7.centos.x86_64.rpm
sudo systemctl start docker
chmod 777 logloop-install-linux64-latest.bin
./logloop-install-linux64-latest.bin -plogloop@201706
cd logloop-install
./install.sh
sudo systemctl start logloop
./post-install.sh
cd ..
sleep 3s
docker cp Caddyfile elk5-cntr:/etc/caddy
docker exec -it elk5-cntr sv stop caddy
docker exec -it elk5-cntr sv start caddy
docker cp defaults.js elk5-cntr:/opt/kibana/src/ui/settings
docker cp chrome.jade elk5-cntr:/opt/kibana/src/ui/views
docker cp ui_app.jade elk5-cntr:/opt/kibana/src/ui/views
docker cp commons.style.css elk5-cntr:/opt/kibana/optimize/bundles
docker cp kibanaWelcomeLogo.svg elk5-cntr:/opt/kibana/optimize/bundles
docker cp logloop-logo.svg elk5-cntr:/opt/kibana/optimize/bundles