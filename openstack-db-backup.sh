#!/bin/sh
set -e

function run() {
    create_date=$(date '+%F')
    filename="openstack-$create_date-backup.sql"

    echo "[`date '+%F %T'`]" "INFO: ssh remote"
    echo "[`date '+%F %T'`]" "INFO: start backup..."
    ssh ${1} bash -c "'
    su - postgres -c pg_dumpall > ~/$filename
    '"
    echo "[`date '+%F %T'`]" "INFO: finished backup..."
    scp ${1}:~/$filename /root/infinitiessoft/openstack-db-backup/
}
run "$@"