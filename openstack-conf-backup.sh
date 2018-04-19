#!/bin/sh

set -e

create_date=$(date '+%F')
dir="openstack-conf-backup-$create_date"
mkdir -p ~/$dir
function controller() {
    for hostname in controller01 controller02 controller03
    do
        ssh $hostname bash -c "'
            mkdir -p ~/$dir
            cp -Rp /etc/apache2 ~/$dir
            cp -Rp /etc/ceilometer ~/$dir
            cp -Rp /etc/ceph ~/$dir
            cp -Rp /etc/cinder ~/$dir
            cp -Rp /etc/cloud ~/$dir
            cp -Rp /etc/ec2api ~/$dir
            cp -Rp /etc/glance ~/$dir
            cp -Rp /etc/heat ~/$dir
            cp -Rp /etc/keystone ~/$dir
            cp -Rp /etc/neutron ~/$dir
            cp -Rp /etc/nova ~/$dir
            cp -Rp /etc/openvswitch ~/$dir
            cp -Rp /etc/rabbitmq ~/$dir
            cp -Rp /etc/sahara ~/$dir
            cp -Rp /etc/ironic ~/$dir
            cd ~/$dir
            tar -cf $hostname.tar *
        '"
        scp $hostname:~/$dir/$hostname.tar ~/$dir
    done
}
function storage() {
    for hostname in storage01 storage02 storage03
    do
        ssh $hostname bash -c "'
            mkdir -p ~/$dir
            cp -Rp /etc/ceph ~/$dir
            cp -Rp /etc/cinder ~/$dir
            cp -Rp /etc/cloud ~/$dir
            cd ~/$dir
            tar -cf $hostname.tar *
        '"
        scp $hostname:~/$dir/$hostname.tar ~/$dir
    done
}
function compute() {
    for hostname in compute01 compute02 compute03 compute04 compute05 compute06 compute07 compute08 compute09 compute10 compute11 compute12 compute13 compute14 compute15 compute16 compute17 compute18 compute19 compute20
    do
        ssh $hostname bash -c "'
            mkdir -p ~/$dir
            cp -Rp /etc/ceilometer ~/$dir
            cp -Rp /etc/ceph ~/$dir
            cp -Rp /etc/libvirt ~/$dir
            cp -Rp /etc/neutron ~/$dir
            cp -Rp /etc/nova ~/$dir
            cp -Rp /etc/openvswitch ~/$dir
            cd ~/$dir
            tar -cf $hostname.tar *
        '"
        scp $hostname:~/$dir/$hostname.tar ~/$dir
    done
}
function run() {
    controller
    storage
    compute
}
run "$@"