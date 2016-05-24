#!/bin/bash

CONFIG_HOST=${CONFIG_HOST:-config.openstack.local}
FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas/env/_formulas}
FORMULA_BRANCH=${FORMULA_BRANCH:-master}
FORMULA_ADDRESS=${FORMULA_ADDRESS:-https://github.com/tcpcloud/workshop-salt-model.git}
RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/workshop-salt-model.git}
RECLASS_BRANCH=${RECLASS_BRANCH:-master}

declare -a FORMULA_SERVICES=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx")


printf "\nPreparing base OS repository ...\n"
which wget > /dev/null || (apt-get update; apt-get install -y wget)

printf "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp tcp-salt" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

printf "\nInstalling salt master ...\n"
apt-get install git salt-master python-reclass -y

printf "\nConfiguring salt minion ...\n"
[ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
printf "id: ${CONFIG_HOST}\n" > /etc/salt/minion.d/minion.conf
printf "master: localhost" >> /etc/salt/minion.d/minion.conf

printf "\nConfiguring salt master ...\n"
cat << 'EOF' > /etc/salt/master.d/master.conf
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

printf "\nConfiguring reclass ...\n"
mkdir /etc/reclass
cat << 'EOF' > /etc/reclass/reclass-config.yml
storage_type: yaml_fs
pretty_print: True
output: yaml
inventory_base_uri: /srv/salt/reclass
EOF

git clone ${RECLASS_ADDRESS} /srv/salt/reclass -b ${RECLASS_BRANCH}
mkdir -p /srv/salt/reclass/classes/service

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
ln -s /usr/share/salt-formulas/env /srv/salt/env/dev

for FORMULA_SERVICE in "${FORMULA_SERVICES[@]}"
do
   printf "\nConfiguring salt formula ${FORMULA_SERVICE} ...\n"
   git clone "https://github.com/tcpcloud/salt-formula-${FORMULA_SERVICE}.git" "${FORMULA_PATH}/${FORMULA_SERVICE}" -b ${FORMULA_BRANCH}
   ln -s "${FORMULA_PATH}/${FORMULA_SERVICE}/${FORMULA_SERVICE}" "/usr/share/salt-formulas/env/${FORMULA_SERVICE}"
   ln -s "${FORMULA_PATH}/${FORMULA_SERVICE}/metadata/service" "/srv/salt/reclass/classes/service/${FORMULA_SERVICE}"
done

printf "\nRestarting services ...\n"
service salt-master restart
service salt-minion restart
salt-call pillar.data --no-color
salt-key -a ${CONFIG_HOST} -y

printf "\nReclass metadata ...\n"
reclass --nodeinfo ${CONFIG_HOST}

printf "\nSalt grains metadata ...\n"
salt-call grains.items --no-color

printf "\nSalt pillar metadata ...\n"
salt-call pillar.data --no-color

printf "\nRunning base states ...\n"
salt-call state.sls linux,openssh,salt.minion,salt.master.service --no-color

printf "\nRunning complete state ...\n"
salt-call state.highstate --no-color
