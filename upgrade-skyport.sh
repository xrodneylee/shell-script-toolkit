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
    echo "[`date '+%F %T'`]" "INFO: start upgrade of skyport "
    tmpdir_new=`mktemp -d`
    tmpdir_old=`mktemp -d`
    unzip -q -d ${tmpdir_new} ${1}
    mv /opt/skyport ${tmpdir_old}
    mv ${tmpdir_new}/skyport /opt
    mv ${tmpdir_old}/skyport/accessconfig.xml /opt/skyport
    sed -i 's#^wrapper.java.command=.*#wrapper.java.command=%JAVA_HOME%/bin/java#' "/opt/skyport/config/wrapper.conf"
    sed -i '/port="8009"/ {s/^/<!--/;s/$/-->/ }' "/opt/skyport/config/server.xml"
    sed -i 's|level="debug"|level="info"|g' "/opt/skyport/config/logback.xml"
    chmod 755 /opt/skyport/bin/*
    chown -R skyport:skyport /opt/skyport
    rm -rfd ${tmpdir_new}
    echo "[`date '+%F %T'`]" "INFO: finished upgrade of skyport "
}
function run() {
    if test $# -ne 0
    then
        stop_service "cloudfusion"
        stop_service "skyport"
        upgrade ${1}
        start_service "skyport"
        start_service "cloudfusion"
    else
        echo "[`date '+%F %T'`]" "ERROR: please join skyport zip file"
    fi
}
run "$@"