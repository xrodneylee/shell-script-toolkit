#!/bin/sh
function run() {
    mkdir -p /mnt/infinitiessoft
    mkfs -t xfs /dev/sdb
    mount /dev/sdb /mnt/infinitiessoft
    cp -R /var/lib/nova/* /mnt/infinitiessoft
    umount /mnt/infinitiessoft
    mount /dev/sdb /var/lib/nova/
    echo "/dev/sdb  /var/lib/nova/  xfs  defaults  0 0" >> /etc/fstab
}
run "$@"