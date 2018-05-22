#!/bin/bash
public_ip= # 172.16.133.1 - 172.16.133.254
neutron_ip= # 172.16.129.1 - 172.16.129.254
admin_ip= # 172.16.121.1 - 172.16.121.254
hostname= # nova10
fqdn= # nova10.braavos.nchc.org.tw





sudo mkdir -p /root/infinitiessoft/tmp
sudo mkdir -p /etc/wicked/scripts

sudo zypper install -y kernel-firmware bridge-utils qemu-kvm qemu libvirt-daemon-driver-qemu qemu-kvm qemu-ovmf-x86_64 libvirt libvirt-python typelib-1_0-Libosinfo-1_0 ceph-common libcephfs1 python-cephfs openvswitch-switch

sudo cat > /etc/zypp/repos.d/Cloud-OpenStack-Newton.repo << EOF

[Cloud-OpenStack-Newton]
name=OpenStack Newton (Stable branch) (openSUSE_Leap_42.2)
type=rpm-md
baseurl=http://download.opensuse.org/repositories/Cloud:/OpenStack:/Newton/openSUSE_Leap_42.2/
gpgcheck=1
gpgkey=http://download.opensuse.org/repositories/Cloud:/OpenStack:/Newton/openSUSE_Leap_42.2/repodata/repomd.xml.key
enabled=1
EOF

sudo zypper --gpg-auto-import-keys install -f -y python-rfc3986 openstack-ceilometer openstack-ceilometer-agent-compute openstack-ceilometer-polling openstack-neutron openstack-neutron-fwaas openstack-neutron-l3-agent openstack-neutron-metadata-agent openstack-neutron-openvswitch-agent openstack-nova openstack-nova-compute openstack-suse-sudo python-castellan python-ceilometer python-cinderclient python-glanceclient python-keystoneauth1 python-keystoneclient python-keystonemiddleware python-microversion_parse python-neutron python-neutron-fwaas python-neutronclient python-nova python-novaclient python-os-brick python-os-client-config python-os-vif python-os-win python-osc-lib python-oslo.cache python-oslo.concurrency python-oslo.config python-oslo.context python-oslo.db python-oslo.i18n python-oslo.log python-oslo.messaging python-oslo.middleware python-oslo.policy python-oslo.privsep python-oslo.reports python-oslo.rootwrap python-oslo.serialization python-oslo.service python-oslo.utils python-oslo.vmware python-osprofiler python-swiftclient


# nova
cat > /etc/nova/nova.conf.d/100-nova.conf << EOF
[DEFAULT]
ssl_only = True
cert =
key =
my_ip=

notify_on_state_change = vm_and_task_state
state_path = /var/lib/nova
enabled_ssl_apis = osapi_compute,metadata
osapi_compute_listen=
osapi_compute_listen_port = 5551
osapi_compute_workers = 4
metadata_listen=
metadata_listen_port = 5552
metadata_workers = 4
instance_usage_audit_period = hour
image_cache_manager_interval = 0
use_rootwrap_daemon = true
vendordata_jsonfile_path = /etc/nova/suse-vendor-data.json
auth_strategy = keystone
memcached_servers =
instances_path = /var/lib/nova/instances
instance_usage_audit = True
block_device_allocate_retries = 180
block_device_allocate_retries_interval = 10
reserved_host_memory_mb = 512
cpu_allocation_ratio = 16
ram_allocation_ratio = 1
disk_allocation_ratio = 1




compute_driver = libvirt.LibvirtDriver
firewall_driver = nova.virt.firewall.NoopFirewallDriver

use_neutron = true
default_floating_pool = floating
dhcpbridge = /usr/bin/nova-dhcpbridge
linuxnet_interface_driver = ""
dhcp_domain = openstack.local
security_group_api = neutron
debug = false
verbose = True
log_dir = /var/log/nova
use_syslog = False
use_stderr = false
rpc_conn_pool_size = 64
executor_thread_pool_size = 256
transport_url = rabbit://nova:5izvsYFHeHbj@172.16.120.108:5672//nova
control_exchange = nova

[api_database]

[cache]
backend = dogpile.cache.memcached
enabled = true
memcache_servers =

[cinder]
catalog_info = volumev2:cinderv2:internalURL
os_region_name = RegionOne
insecure = False
cross_az_attach = true

[conductor]
workers=4

[database]

[glance]
host = cluster-proposal-1.braavos.nchc.org.tw
port = 9292
protocol = https
api_servers = https://cluster-proposal-1.braavos.nchc.org.tw:9292
api_insecure = False


[key_manager]
fixed_key = 576e644a356d317664414a4f

[keystone_authtoken]
auth_type = password
auth_uri = https://service.braavos.nchc.org.tw:5000/v3/
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:5000/v3/
auth_version= v3.0
insecure = false
region_name = RegionOne
username = nova
password = u3qhZupnVg0F
project_name = service
project_domain_name = Default
user_domain_name = Default

[libvirt]
virt_type = kvm
live_migration_inbound_addr=
block_migration_flag = VIR_MIGRATE_UNDEFINE_SOURCE, VIR_MIGRATE_PEER2PEER, VIR_MIGRATE_NON_SHARED_INC, VIR_MIGRATE_LIVE

use_virtio_for_bridges = true

[neutron]
service_metadata_proxy = true
metadata_proxy_shared_secret = neRBCbPeb7W8
url = https://cluster-proposal-1.braavos.nchc.org.tw:9696
region_name = RegionOne
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:5000/v2.0/
auth_type = password
insecure = False
password = DLpEmBaCKz5d
project_name = service
tenant_name = service
timeout = 30
username = neutron

[oslo_concurrency]
lock_path = /var/run/nova

[oslo_messaging_notifications]
driver = messagingv2

[oslo_messaging_rabbit]
rabbit_use_ssl = false
heartbeat_timeout_threshold = 10

[serial_console]
enabled = False
base_url = ws://service.braavos.nchc.org.tw:6083/
proxyclient_address=
serialproxy_host=
serialproxy_port = 5556

[ssl]

cert_file =
key_file =

[trusted_computing]

[vmware]

[vnc]
enabled = True
keymap = en-us
vncserver_listen = "0.0.0.0"
vncserver_proxyclient_address=
novncproxy_host=
novncproxy_port = 5554
novncproxy_base_url = https://service.braavos.nchc.org.tw:6080/vnc_auto.html
xvpvncproxy_host=

[wsgi]
max_header_line = 16384
ssl_cert_file =
ssl_key_file =
keep_alive = false


EOF

# neutron
sudo mv /etc/neutron/plugins/ml2/openvswitch_agent.ini /root/infinitiessoft/tmp

cat > /etc/neutron/neutron.conf.d/100-neutron.conf << EOF
[DEFAULT]
bind_host = 0.0.0.0
bind_port = 9696
auth_strategy = keystone
core_plugin = ml2
service_plugins = neutron.services.l3_router.l3_router_plugin.L3RouterPlugin, neutron.services.metering.metering_plugin.MeteringPlugin, neutron_fwaas.services.firewall.fwaas_plugin.FirewallPlugin, neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2
dns_domain = openstack.local
allow_overlapping_ips = True
global_physnet_mtu = 1500
use_ssl = True
api_workers = 4
rpc_workers = 1
dhcp_agents_per_network = 3
router_distributed = True
debug = False
verbose = True
log_dir = /var/log/neutron
use_syslog = False
use_stderr = false
transport_url = rabbit://nova:5izvsYFHeHbj@172.16.120.108:5672//nova
control_exchange = neutron
max_header_line = 16384
wsgi_keep_alive = false

[agent]
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf
root_helper_daemon = sudo neutron-rootwrap-daemon /etc/neutron/rootwrap.conf

[database]
min_pool_size = 30
max_pool_size =
max_overflow = 10
pool_timeout = 30

[keystone_authtoken]
auth_type = password
auth_uri = https://service.braavos.nchc.org.tw:5000/v3/
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:5000/v3/
auth_version = v3.0
insecure = false
region_name = RegionOne
username = neutron
password = DLpEmBaCKz5d
project_name = service
project_domain_name = Default
user_domain_name = Default

[nova]
region_name = RegionOne
endpoint_type = internal
auth_url = "https://cluster-proposal-1.braavos.nchc.org.tw:5000"
auth_type = password
password = DLpEmBaCKz5d
project_name = service
username = neutron

[oslo_concurrency]
lock_path = /var/run/neutron

[oslo_messaging_notifications]
driver = neutron.openstack.common.notifier.rpc_notifier

[oslo_messaging_rabbit]
rabbit_use_ssl = false
heartbeat_timeout_threshold = 10

[ssl]
cert_file = /etc/cloud/ssl/certs/signing_cert.pem
key_file = /etc/cloud/private/signing_key.pem
EOF

cat > /etc/neutron/neutron-metadata-agent.conf.d/100-metadata_agent.conf << EOF
[DEFAULT]
nova_metadata_ip = cluster-proposal-1.braavos.nchc.org.tw
metadata_proxy_shared_secret = neRBCbPeb7W8
nova_metadata_protocol = https
nova_metadata_insecure = False
metadata_workers = 4
debug = False
[AGENT]
EOF

cat > /etc/neutron/neutron.conf.d/110-neutron_lbaas.conf << EOF
[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
[quotas]
[service_auth]
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:5000/v2.0/
admin_tenant_name = service
admin_user = neutron
admin_password = DLpEmBaCKz5d
region_name = RegionOne
[service_providers]
service_provider=LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
[certificates]
EOF

cat > /etc/neutron/neutron-l3-agent.conf.d/100-agent.conf << EOF
[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
agent_mode = dvr
metadata_port = 9697
send_arp_for_ha = 3
handle_internal_only_routers = True
external_network_bridge =
periodic_interval = 40
periodic_fuzzy_delay = 5
debug = False
[AGENT]
extensions = fwaas

[fwaas]
agent_version = v1
driver = iptables
enabled = True

EOF

cat > /etc/neutron/plugins/ml2/openvswitch_agent.ini << EOF
[DEFAULT]
[agent]
tunnel_types = vxlan
l2_population = True
arp_responder = True
enable_distributed_routing = True
[ovs]
tunnel_bridge = br-tunnel
ovsdb_interface = native
of_interface = native
local_ip=
bridge_mappings = floating:br-public
[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

# ceilometer
cat > /etc/ceilometer/ceilometer.conf.d/100-ceilometer.conf << EOF
[DEFAULT]
shuffle_time_before_polling_task = 15
hypervisor_inspector = libvirt
libvirt_type = kvm
nova_http_log_debug = false
host=
debug = false
verbose = true
log_dir = /var/log/ceilometer
use_stderr = false
transport_url = rabbit://nova:5izvsYFHeHbj@172.16.120.108:5672//nova

[collector]
workers = 4

[api]
default_api_return_limit = 1000

[database]
metering_time_to_live = 2592000
event_time_to_live = 2592000
connection = postgresql://ceilometer:O8vMRvZ31euK@172.16.120.107/ceilometer

[keystone_authtoken]
auth_uri = https://service.braavos.nchc.org.tw:5000/v3/
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:35357
auth_version = v3.0
region_name = RegionOne
username = ceilometer
password = 3JZj5Yq82VIu
project_name = service
project_domain_name = Default
user_domain_name = Default
auth_type = password

[notification]
workers = 4

[oslo_concurrency]
lock_path = /var/run/ceilometer

[publisher]
telemetry_secret = efxOFHaL0Usl

[service_credentials]
region_name = RegionOne
interface = internalURL
auth_type = password
auth_url = https://cluster-proposal-1.braavos.nchc.org.tw:5000/v3/
project_name = service
default_domain_id = default
default_domain_name = Default
username = ceilometer
password = 3JZj5Yq82VIu

[service_types]
neutron_lbaas_version = v2

[vmware]
host_ip =
host_port = 443
host_username =
host_password =

[oslo_messaging_rabbit]
rabbit_use_ssl = false
heartbeat_timeout_threshold = 10
EOF

# ceph
cat > /etc/ceph/ceph.client.admin.keyring << EOF
[client.admin]
        key = AQCsuXtanw3LIRAAGn90sM4Vut/GLp2oZbUxsA==
EOF

cat > /etc/ceph/ceph.conf << EOF
[global]
        ; enable secure authentication
        auth cluster required = cephx
        auth service required = cephx
        auth client required = cephx
        cephx require signatures = true

        ; allow ourselves to open a lot of files
        max open files = 131072

        ; set log file
        log file = /var/log/ceph/$name.log
        ; log_to_syslog = true        ; uncomment this line to log to syslog

        ; set up pid files
        pid file = /var/run/ceph/$name.pid

        ; provide the unique identifier for object store
        fsid =

        ; specify the initial monitors of the cluster in to establish a quorum
        mon initial members = public.d3c-fd-fe-36-f7-40, public.d3c-fd-fe-36-f4-c0, public.d3c-fd-fe-36-f9-c0
        mon host = 172.16.132.3, 172.16.132.2, 172.16.132.4

        ; configure a public and cluster network
        public network =
        cluster network =

        ; replication level, number of data copies
        osd pool default size = 3
        ; number of placement groups for a pool
        osd pool default pg num = 8
        ; default number of placement groups for placement for a pool
        osd pool default pgp num = 8

        # Choose a reasonable crush leaf type.
        # 0 for a 1-node cluster.
        # 1 for a multi node cluster in a single rack
        # 2 for a multi node, multi chassis cluster with multiple hosts in a chassis
        # 3 for a multi node cluster with hosts across racks, etc.
        osd crush chooseleaf type = 1


; monitors
;  You need at least one.  You need at least three if you want to
;  tolerate any node failures.  Always create an odd number.
[mon]
    mon data = /var/lib/ceph/mon/ceph-$id

        ; Timing is critical for monitors, but if you want to allow the clocks to drift a
        ; bit more, you can specify the max drift.
        ;mon clock drift allowed = 1

        ; Tell the monitor to backoff from this warning for 30 seconds
        ;mon clock drift warn backoff = 30

    ; logging, for debugging monitor crashes, in order of
    ; their likelihood of being helpful :)
    ;debug ms = 1
    ;debug mon = 20
    ;debug paxos = 20
    ;debug auth = 20

    ; The IP address for the public (front-side) network. Set for each daemon.
    public addr = 172.16.120.102


; osd
;  You need at least one.  Two if you want data to be replicated.
;  Define as many as you like.
[osd]
    ; This is where the osd expects its data
    osd data = /var/lib/ceph/osd/ceph-$id

    ; Ideally, make the journal a separate disk or partition.
    ; 1-10GB should be enough; more if you have fast or many
    ; disks.  You can use a file under the osd data dir if need be
    ; (e.g. /data/$name/journal), but it will be slower than a
    ; separate disk or partition.
        ; This is an example of a file-based journal.
    osd journal = /var/lib/ceph/osd/ceph-$id/journal
    osd journal size =

        ; If you want to run the journal on a tmpfs (don't), disable DirectIO
        ;journal dio = false

        ; You can change the number of recovery operations to speed up recovery
        ; or slow it down if your machines can't handle it
        ; osd recovery max active = 3

    ; osd logging to debug osd issues, in order of likelihood of being
    ; helpful
    ;debug ms = 1
    ;debug osd = 20
    ;debug filestore = 20
    ;debug journal = 20

    fstype = xfs

    ; ### The below options only apply if you're using mkcephfs
    ; ### and the devs options
        ; The filesystem used on the volumes
        osd mkfs type = xfs
        ; If you want to specify some other mount options, you can do so.
        ; for other filesystems use 'osd mount options $fstype'
    osd mount options xfs = rw,noatime,inode64,logbsize=256k
    ; The options used to format the filesystem via mkfs.$fstype
        ; for other filesystems use 'osd mkfs options $fstype'
    ; osd mkfs options btrfs =




EOF

# libvirtd
sed -i 's/#listen_tcp = 1/listen_tcp = 1/g' "/etc/libvirt/libvirtd.conf"
sed -i 's/#auth_tcp = "sasl"/auth_tcp = "none"/g' "/etc/libvirt/libvirtd.conf"
sed -i "s/^#host_uuid =.*/host_uuid = \"$(uuidgen)\"/g" "/etc/libvirt/libvirtd.conf"

sed -i 's/#security_driver = "apparmor"/security_driver = "none"/g' "/etc/libvirt/qemu.conf"
sed -i 's/#user = "root"/user = "qemu"/g' "/etc/libvirt/qemu.conf"
sed -i 's/#group = "root"/group = "kvm"/g' "/etc/libvirt/qemu.conf"
tee -a /etc/libvirt/qemu.conf << EOF
nvram = [
   "/usr/share/qemu/ovmf-x86_64-ms-code.bin:/usr/share/qemu/ovmf-x86_64-ms-vars.bin",
   "/usr/share/qemu/aavmf-aarch64-code.bin:/usr/share/qemu/aavmf-aarch64-vars.bin"
]
EOF

# integration of ceph

cat > /etc/ceph/ceph-secret-0b38f234-d4e5-4b7d-aca4-1863adbdb25a.xml  << EOF
<secret ephemeral='no' private='no'>
  <uuid>0b38f234-d4e5-4b7d-aca4-1863adbdb25a</uuid>
  <usage type='ceph'>
    <name>nova-0b38f234-d4e5-4b7d-aca4-1863adbdb25a secret</name>
  </usage>
</secret>
EOF


# chown
chown root:nova /etc/nova/nova.conf.d/100-nova.conf
chown root:neutron /etc/neutron/neutron.conf.d/100-neutron.conf
chown root:neutron /etc/neutron/neutron.conf.d/110-neutron_lbaas.conf
chown root:neutron /etc/neutron/neutron-l3-agent.conf.d/100-agent.conf
chown root:ceilometer /etc/ceilometer/ceilometer.conf.d/100-ceilometer.conf


sudo mv /etc/sysconfig/network/ifcfg-eth0 /root/infinitiessoft/tmp
sudo mv /etc/sysconfig/network/ifcfg-eth1 /root/infinitiessoft/tmp
sudo mv /etc/resolv.conf /root/infinitiessoft/tmp

tee -a /etc/hosts << EOF
$admin_ip $fqdn $hostname
EOF

hostnamectl set-hostname $hostname


# network
sudo cat > /etc/wicked/scripts/br-ironic-pre-up << EOF
#! /bin/bash

ovs-vsctl br-exists br-ironic || exit 0
ovs-vsctl set Bridge br-ironic other-config:datapath-id=abd3feac14f66274
ovs-vsctl del-fail-mode br-ironic
EOF

sudo cat > /etc/wicked/scripts/br-public-pre-up << EOF
#! /bin/bash

ovs-vsctl br-exists br-public || exit 0
ovs-vsctl set Bridge br-public other-config:datapath-id=a61e3ff809f4c617
ovs-vsctl del-fail-mode br-public
EOF

sudo cat > /etc/resolv.conf << EOF
search braavos.nchc.org.tw
nameserver 127.0.0.1
nameserver 192.168.120.10
nameserver 172.16.120.106
EOF

sudo cat > /etc/sysconfig/network/ifcfg-eth0.300 << EOF
NAME='eth0.300'
STARTMODE=auto
BOOTPROTO=static
VLAN_ID=300
ETHERDEVICE='eth0'
IPADDR=$public_ip/23
EOF

sudo cat > /etc/sysconfig/network/ifcfg-eth0.400 << EOF
NAME='eth0.400'
STARTMODE=auto
BOOTPROTO=static
VLAN_ID=400
ETHERDEVICE='eth0'
IPADDR=$neutron_ip/23
EOF

sudo cat > /etc/sysconfig/network/ifcfg-eth0.12 << EOF
NAME='eth0.12'
STARTMODE=auto
BOOTPROTO=static
VLAN_ID=12
ETHERDEVICE='eth0'
EOF

sudo cat > /etc/sysconfig/network/ifcfg-br-ironic << EOF
NAME='br-ironic'
STARTMODE=auto
BOOTPROTO=static
OVS_BRIDGE=yes
OVS_BRIDGE_PORT_DEVICE_0='eth0'
IPADDR=$admin_ip/22
PRE_UP_SCRIPT='wicked:/etc/wicked/scripts/br-ironic-pre-up'
EOF

sudo cat > /etc/sysconfig/network/ifcfg-br-public << EOF
NAME='br-public'
STARTMODE=auto
BOOTPROTO=static
OVS_BRIDGE=yes
OVS_BRIDGE_PORT_DEVICE_0='br12'
PRE_UP_SCRIPT='wicked:/etc/wicked/scripts/br-public-pre-up'
EOF

sudo cat > /etc/sysconfig/network/ifcfg-br12 << EOF
NAME='br12'
STARTMODE=auto
BOOTPROTO=static
BRIDGE=yes
BRIDGE_PORTS='["eth0.12"]'
EOF

sudo cat > /etc/sysconfig/network/ifcfg-eth0 << EOF
NAME='eth0'
STARTMODE=auto
BOOTPROTO=none
EOF

sudo cat > /etc/sysconfig/network/ifroute-eth0.300 << EOF
default 192.168.132.1
EOF

# libvirt
sed -i "s|^#listen_addr =.*|listen_addr = '$admin_ip'|g" "/etc/libvirt/libvirtd.conf"

# nova
sed -i "s|my_ip=|my_ip = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|osapi_compute_listen=|osapi_compute_listen = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|metadata_listen=|metadata_listen = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|live_migration_inbound_addr=|live_migration_inbound_addr = '$fqdn'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|proxyclient_address=|proxyclient_address = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|serialproxy_host=|serialproxy_host = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|vncserver_proxyclient_address=|vncserver_proxyclient_address = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|novncproxy_host=|novncproxy_host = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"
sed -i "s|xvpvncproxy_host=|xvpvncproxy_host = '$admin_ip'|g" "/etc/nova/nova.conf.d/100-nova.conf"

# neutron
sed -i "s|local_ip=|local_ip = '$neutron_ip'|g" "/etc/neutron/plugins/ml2/openvswitch_agent.ini"

#ceilometer
sed -i "s|host=|host = '$hostname'|g" "/etc/ceilometer/ceilometer.conf.d/100-ceilometer.conf"

# services
systemctl enable libvirtd 
systemctl enable openvswitch
systemctl enable openstack-ceilometer-agent-compute
systemctl enable openstack-neutron-l3-agent
systemctl enable openstack-neutron-metadata-agent
systemctl enable openstack-neutron-openvswitch-agent
systemctl enable openstack-neutron-ovs-cleanup
systemctl enable openstack-nova-compute

systemctl start openvswitch
systemctl restart network

# bridge
brctl addbr br12
brctl addif br12 eth0.12

systemctl start libvirtd 
systemctl start openstack-ceilometer-agent-compute
systemctl start openstack-neutron-l3-agent
systemctl start openstack-neutron-metadata-agent
systemctl start openstack-neutron-openvswitch-agent
systemctl start openstack-neutron-ovs-cleanup
systemctl start openstack-nova-compute

key=$(ceph -k /etc/ceph/ceph.client.admin.keyring -c /etc/ceph/ceph.conf auth get-or-create-key client.cinder)
virsh secret-define --file /etc/ceph/ceph-secret-0b38f234-d4e5-4b7d-aca4-1863adbdb25a.xml
virsh secret-set-value --secret 0b38f234-d4e5-4b7d-aca4-1863adbdb25a --base64 $key

rm /etc/ceph/ceph-secret-0b38f234-d4e5-4b7d-aca4-1863adbdb25a.xml

systemctl restart libvirtd
systemctl restart openstack-nova-compute