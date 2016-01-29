#!/bin/bash

CONFIG_HOST=${CONFIG_HOST:-config.openstack.local}

RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/workshop-salt-model.git}

echo "Preparing base OS"
which wget > /dev/null || (apt-get update; apt-get install -y wget)

echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp tcp-salt" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

echo "Configuring salt master ..."
apt-get install -y salt-master
apt-get install -y salt-formula-linux salt-formula-reclass salt-formula-salt salt-formula-openssh salt-formula-ntp salt-formula-git salt-formula-graphite salt-formula-collectd salt-formula-sensu salt-formula-heka

cat << 'EOF' > /etc/salt/master.d/master.conf
file_roots:
  base:
  - /usr/share/salt-formulas/env
pillar_opts: False
open_mode: True
reclass: &reclass
  storage_type: yaml_fs
  inventory_base_uri: /srv/salt/reclass
ext_pillar:
  - reclass: *reclass
master_tops:
  reclass: *reclass
EOF

echo "Configuring reclass ..."
git clone $RECLASS_ADDRESS /srv/salt/reclass -b master
mkdir -p /srv/salt/reclass/classes/service

for i in /usr/share/salt-formulas/reclass/service/*; do
  ln -s $i /srv/salt/reclass/classes/service/
done

[ ! -d /etc/reclass ] && mkdir /etc/reclass
cat << 'EOF' > /etc/reclass/reclass-config.yml
storage_type: yaml_fs
pretty_print: True
output: yaml
inventory_base_uri: /srv/salt/reclass
EOF

echo "Configuring salt minion ..."
apt-get install -y salt-minion
[ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
cat << EOF > /etc/salt/minion.d/minion.conf
id: $CONFIG_HOST
master: localhost
EOF

echo "Restarting services ..."
service salt-master restart
rm -f /etc/salt/pki/minion/minion_master.pub
service salt-minion restart

echo "Showing system info and metadata ..."
salt-call grains.items
salt-call pillar.data
reclass -n $CONFIG_HOST

echo "Running complete state ..."
salt-call state.sls linux,openssh,salt.minion
salt-call state.sls salt.master
salt-call state.highstate
