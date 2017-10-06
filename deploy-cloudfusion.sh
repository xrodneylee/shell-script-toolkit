#!/bin/bash
function stop_service() {
    echo "[`date '+%F %T'`]" "INFO: stop service " ${1}
    systemctl stop ${1}
    sleep 1
}
function start_service() {
    echo "[`date '+%F %T'`]" "INFO: start service " ${1}
    systemctl start ${1}
    sleep 3
}
function upgrade() {
    echo "[`date '+%F %T'`]" "INFO: start upgrade of cloudfusion "
    rm /opt/cloudfusion-Datacenter/webapps/ROOT -rfd
    rm /opt/cloudfusion-Datacenter/webapps/ROOT.war
    mv ${1} /opt/cloudfusion-Datacenter/webapps/
    chmod 0755 /opt/cloudfusion-Datacenter/webapps/ROOT.war
    chown cloudfusion:cloudfusion /opt/cloudfusion-Datacenter/webapps/ROOT.war
    echo "[`date '+%F %T'`]" "INFO: finished upgrade of cloudfusion "
}
function run() {
    stop_service "cloudfusion"
    upgrade /tmp/ROOT.war
    start_service "cloudfusion"
}
run "$@"