#!/bin/sh
function sync_admin() {
    systemctl stop ntpd
    ntpdate tock.stdtime.gov.tw
    systemctl start ntpd
}
function sync_nodes() {
    
}
function run() {
    sync_admin &&
    sync_nodes
}
run "$@"