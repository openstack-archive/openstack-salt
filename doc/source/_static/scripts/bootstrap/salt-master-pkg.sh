#!/bin/bash -x

printf "\nPreparing base OS repository ...\n"
which wget > /dev/null || (apt-get update; apt-get install -y wget)

printf "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp tcp-salt" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

printf "\nInstalling salt master ...\n"
apt-get install git salt-master python-reclass -y

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

git clone ${RECLASS_ADDRESS} /srv/salt/reclass -b ${RECLASS_BRANCH}
mkdir -p /srv/salt/reclass/classes/service
mkdir -p /usr/share/salt-formulas/reclass/service
