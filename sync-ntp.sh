#!/bin/sh
function sync_admin() {
    systemctl stop ntpd
    ntpdate tock.stdtime.gov.tw
    systemctl start ntpd
}
function sync_nodes() {
    for hostname in controller01,controller02,controller03
    do
        ssh $hostname 'systemctl restart ntpd'
    done
}
function run() {
    sync_admin &&
    sync_nodes
}
run "$@"