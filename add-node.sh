#!/bin/sh
function add_node() {
    # Node details
    inventory_hostname=${1}
    Port1NIC_MACAddress=${2}

    # IPMI details
    ipmi_address=${3}
    ipmi_password="admin"
    ipmi_user="admin"

    # Image details belonging to a particular node
    image_vcpu=8
    image_ram=32768
    image_disk=80
    image_total_disk_size=3600
    image_cpu_arch="x86_64"

    #KERNEL_IMAGE=$(glance image-list | awk '/ironic-sahara-kernel/ {print $2}')
    #INITRAMFS_IMAGE=$(glance image-list | awk '/ironic-sahara-ramdisk/ {print $2}')
    #QCOW2_IMAGE=
    DEPLOY_RAMDISK=$(glance image-list | awk '/tiniya-ramdisk/ {print $2}')
    DEPLOY_KERNEL=$(glance image-list | awk '/tiniya-kernel/ {print $2}')


    if ironic node-list | grep "$inventory_hostname"; then
        NODE_UUID=$(ironic node-list | awk "/$inventory_hostname/ {print \$2}")
    else
        NODE_UUID=$(ironic node-create \
        -d pxe_ipmitool \
        -i ipmi_address="$ipmi_address" \
        -i ipmi_password="$ipmi_password" \
        -i ipmi_username="$ipmi_user" \
        -i deploy_ramdisk="${DEPLOY_RAMDISK}" \
        -i deploy_kernel="${DEPLOY_KERNEL}" \
        -n $inventory_hostname | awk '/ uuid / {print $4}')
        ironic port-create -n "$NODE_UUID" \
                        -a $Port1NIC_MACAddress
    fi

    #          instance_info/image_source=$QCOW2_IMAGE \
    #          instance_info/kernel=$KERNEL_IMAGE \
    #          instance_info/ramdisk=$INITRAMFS_IMAGE \

    ironic node-update "$NODE_UUID" add \
            driver_info/deploy_kernel=$DEPLOY_KERNEL \
            driver_info/deploy_ramdisk=$DEPLOY_RAMDISK \
            instance_info/root_gb=40 \
            properties/cpus=$image_vcpu \
            properties/memory_mb=$image_ram \
            properties/local_gb=$image_disk \
            properties/size=$image_total_disk_size \
            properties/cpu_arch=$image_cpu_arch \
            properties/capabilities=memory_mb:$image_ram,local_gb:$image_disk,cpu_arch:$image_cpu_arch,cpus:$image_vcpu,boot_option:local
}
function run() {
    if test $# -ne 0
    then
        add_node ${1} ${2} ${3}
    else
        echo "[`date '+%F %T'`]" "ERROR: please join hostname, MAC, ipmi_address"
    fi
}
run "$@"