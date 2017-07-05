#!/bin/sh
# author : guanpu.lee

cd /home/iss-user/tomcatitri
sudo sh bin/shutdown.sh
sudo cp webapps/cloudfusion.war backup/cloudfusion_$(date +"%m_%d_%Y_%H_%M_%S")_backup.war
sudo ls | grep -P "cloudfusion.*" | xargs -d"\n" rm -rf
sudo cp /tmp/cloudfusion.war webapps/cloudfusion.war
sudo rm -f  /tmp/cloudfusion.war
sudo sh bin/startup.sh