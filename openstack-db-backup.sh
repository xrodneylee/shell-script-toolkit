#!/bin/sh
function run() {
    create_date=$(date '+%F')
    filename="openstack-$create_date-backup.sql"

    echo "[`date '+%F %T'`]" "INFO: ssh remote"
    echo "[`date '+%F %T'`]" "INFO: start backup..."
    ssh controller02 bash -c "'
    su - postgres -c pg_dumpall > ~/$filename
    '"
    echo "[`date '+%F %T'`]" "INFO: finished backup..."
    scp controller02:~/$filename /root/infinitiessoft/openstack-db-backup/
}
run "$@"