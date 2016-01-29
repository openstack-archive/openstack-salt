#!/bin/bash

if [ -z "$CONFIG_HOST" ]; then
    export CONFIG_HOST = 'config'
fi

if [ -z "$RECLASS_ADDRESS" ]; then
    export RECLASS_ADDRESS = 'https://github.com/tcpcloud/workshop-salt-model.git'
fi

echo "Preparing base OS"
which wget > /dev/null || (apt-get update; apt-get install -y wget)

echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp tcp-salt" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

echo "Configuring salt master ..."
apt-get install salt-master -y

echo "Configuring salt minion ..."
[ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
echo "id: $node_name" >> /etc/salt/minion.d/minion.conf
echo "master: localhost" >> /etc/salt/minion.d/minion.conf
cat << 'EOF' >> /etc/salt/master.d/master.conf
file_roots:
  base:
  - /usr/share/salt-formulas/env
  dev:
  - /srv/salt/env/dev
pillar_opts: False
reclass: &reclass
  storage_type: yaml_fs
  inventory_base_uri: /srv/salt/reclass
ext_pillar:
  - reclass: *reclass
master_tops:
  reclass: *reclass
EOF

env

echo "Getting salt formulas ..."
ssh-keyscan -H -t ecdsa git.tcpcloud.eu >> /root/.ssh/known_hosts
git clone git@git.tcpcloud.eu:saltstack-formulas/linux-formula.git /usr/share/salt-formulas/env/_formulas/linux -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/reclass-formula.git /usr/share/salt-formulas/env/_formulas/reclass -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/salt-formula.git /usr/share/salt-formulas/env/_formulas/salt -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/openssh-formula.git /usr/share/salt-formulas/env/_formulas/openssh -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/git-formula.git /usr/share/salt-formulas/env/_formulas/git -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/ntp-formula.git /usr/share/salt-formulas/env/_formulas/ntp -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/nginx-formula.git /usr/share/salt-formulas/env/_formulas/nginx -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/collectd-formula.git /usr/share/salt-formulas/env/_formulas/collectd -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/sensu-formula.git /usr/share/salt-formulas/env/_formulas/sensu -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/sphinx-formula.git /usr/share/salt-formulas/env/_formulas/sphinx -b $formulas_branch
git clone git@git.tcpcloud.eu:saltstack-formulas/heka-formula.git /usr/share/salt-formulas/env/_formulas/heka -b $formulas_branch
git clone $reclass_address /srv/salt/reclass -b $reclass_branch

echo "Configuring formula defintions ..."
ln -s /usr/share/salt-formulas/env/_formulas/linux/linux /usr/share/salt-formulas/env/linux
ln -s /usr/share/salt-formulas/env/_formulas/reclass/reclass /usr/share/salt-formulas/env/reclass
ln -s /usr/share/salt-formulas/env/_formulas/salt/salt /usr/share/salt-formulas/env/salt
ln -s /usr/share/salt-formulas/env/_formulas/openssh/openssh /usr/share/salt-formulas/env/openssh
ln -s /usr/share/salt-formulas/env/_formulas/git/git /usr/share/salt-formulas/env/git
ln -s /usr/share/salt-formulas/env/_formulas/ntp/ntp /usr/share/salt-formulas/env/ntp
ln -s /usr/share/salt-formulas/env/_formulas/nginx/nginx /usr/share/salt-formulas/env/nginx
ln -s /usr/share/salt-formulas/env/_formulas/collectd/collectd /usr/share/salt-formulas/env/collectd
ln -s /usr/share/salt-formulas/env/_formulas/sensu/sensu /usr/share/salt-formulas/env/sensu
ln -s /usr/share/salt-formulas/env/_formulas/sphinx/sphinx /usr/share/salt-formulas/env/sphinx
ln -s /usr/share/salt-formulas/env/_formulas/heka/heka /usr/share/salt-formulas/env/heka

echo "Configuring reclass metadata ..."
mkdir -p /srv/salt/reclass/classes/service
ln -s /usr/share/salt-formulas/env/_formulas/linux/metadata/service /srv/salt/reclass/classes/service/linux
ln -s /usr/share/salt-formulas/env/_formulas/reclass/metadata/service /srv/salt/reclass/classes/service/reclass
ln -s /usr/share/salt-formulas/env/_formulas/salt/metadata/service /srv/salt/reclass/classes/service/salt
ln -s /usr/share/salt-formulas/env/_formulas/openssh/metadata/service /srv/salt/reclass/classes/service/openssh
ln -s /usr/share/salt-formulas/env/_formulas/git/metadata/service /srv/salt/reclass/classes/service/git
ln -s /usr/share/salt-formulas/env/_formulas/ntp/metadata/service /srv/salt/reclass/classes/service/ntp
ln -s /usr/share/salt-formulas/env/_formulas/nginx/metadata/service /srv/salt/reclass/classes/service/nginx
ln -s /usr/share/salt-formulas/env/_formulas/collectd/metadata/service /srv/salt/reclass/classes/service/collectd
ln -s /usr/share/salt-formulas/env/_formulas/sensu/metadata/service /srv/salt/reclass/classes/service/sensu
ln -s /usr/share/salt-formulas/env/_formulas/sphinx/metadata/service /srv/salt/reclass/classes/service/sphinx
ln -s /usr/share/salt-formulas/env/_formulas/heka/metadata/service /srv/salt/reclass/classes/service/heka

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
ln -s /usr/share/salt-formulas/env /srv/salt/env/dev

mkdir /etc/reclass
cat << 'EOF' >> /etc/reclass/reclass-config.yml
storage_type: yaml_fs
pretty_print: True
output: yaml
inventory_base_uri: /srv/salt/reclass
EOF

echo "Restarting services ..."
service salt-master restart
sleep 5
service salt-minion restart
sleep 5
salt-key -a $node_name -y
echo "Showing system raw metadata ..."
reclass --nodeinfo $node_name
echo "Showing system info and parsed metadata ..."
salt-call grains.items --no-color
salt-call pillar.data --no-color
echo "Running complete state ..."
salt-call state.sls linux,openssh,salt.minion --no-color
salt-call state.sls salt.master --no-color
salt-call state.highstate --no-color
