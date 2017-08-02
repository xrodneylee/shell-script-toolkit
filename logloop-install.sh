#!/bin/sh
# author : guanpu.lee

set -e

DOCKER_FILE="docker-ce-17.06.0.ce-1.el7.centos.x86_64.rpm"

LOGLOOP_FILE="logloop-install-linux64-latest.bin"
LOGLOOP_PASS="logloop@201706"
DATA_DIR="/srv/logloop"

DOCKER_VOLUME_LOCAL_PERSIST="local-persist-linux-amd64"
DOCKER_VOLUME_LOCAL_PERSIST_DEST="/usr/bin/docker-volume-local-persist"
SYSTEMD_CONFIG_URL="systemd.service"
SYSTEMD_CONFIG_DEST="/etc/systemd/system/docker-volume-local-persist.service"

function install_docker() {
    sudo yum install -y ${DOCKER_FILE}
    sudo systemctl start docker
}
function create_volume() {
    mv ${DOCKER_VOLUME_LOCAL_PERSIST} ${DOCKER_VOLUME_LOCAL_PERSIST_DEST}
    chmod +x ${DOCKER_VOLUME_LOCAL_PERSIST_DEST}

    mv ${SYSTEMD_CONFIG_URL} ${SYSTEMD_CONFIG_DEST}

    sudo systemctl daemon-reload
    sudo systemctl enable docker-volume-local-persist
    sudo systemctl start docker-volume-local-persist
    sudo systemctl status --full --no-pager docker-volume-local-persist

    docker volume create \
            -d local-persist \
            -o "mountpoint=${DATA_DIR}" \
            --name="es_data"
}
function install_logloop() {
    chmod 755 ${LOGLOOP_FILE}
    ./${LOGLOOP_FILE} -p${LOGLOOP_PASS}
    cd logloop-install
    ./install.sh
    sudo systemctl start logloop
    sudo systemctl enable logloop
}
function change_https_to_http() {
    docker cp ../Caddyfile elk5-cntr:/etc/caddy
    docker exec -it elk5-cntr sv stop caddy
    docker exec -it elk5-cntr sv start caddy
}
function change_logloop_logo() {
    docker cp defaults.js elk5-cntr:/opt/kibana/src/ui/settings
    docker cp chrome.jade elk5-cntr:/opt/kibana/src/ui/views
    docker cp ui_app.jade elk5-cntr:/opt/kibana/src/ui/views
    docker cp commons.style.css elk5-cntr:/opt/kibana/optimize/bundles
    docker cp kibanaWelcomeLogo.svg elk5-cntr:/opt/kibana/optimize/bundles
    docker cp logloop-logo.svg elk5-cntr:/opt/kibana/optimize/bundles
}
function logloop_post_install() {
    ./logloop/post-install.sh
}
function run() {
    install_docker &&
    create_volume &&
    install_logloop &&
    change_https_to_http &&
    change_logloop_logo &&
    logloop_post_install
}
run "$@"