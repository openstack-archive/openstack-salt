#!/bin/bash

FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}
CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}

echo "Configuring necessary formulas ..."
which wget > /dev/null || (apt-get update; apt-get install -y wget)

echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty tcp-salt" > /etc/apt/sources.list.d/tcpcloud-salt.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

[ ! -d /srv/salt/reclass/classes/service ] && mkdir -p /srv/salt/reclass/classes/service

declare -a FORMULA_SERVICES=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx")

for FORMULA_SERVICE in "${FORMULA_SERVICES[@]}"; do
    echo -e "\nConfiguring salt formula ${FORMULA_SERVICE} ...\n"
    [ ! -d "${FORMULA_PATH}/env/${FORMULA_SERVICE}" ] && \
        apt-get install -y salt-formula-${FORMULA_SERVICE}
    [ ! -L "/srv/salt/reclass/classes/service/${FORMULA_SERVICE}" ] && \
        ln -s ${FORMULA_PATH}/reclass/service/${FORMULA_SERVICE} /srv/salt/reclass/classes/service/${FORMULA_SERVICE}
done

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
[ ! -L /srv/salt/env/prd ] && ln -s ${FORMULA_PATH}/env /srv/salt/env/prd

echo -e "\nRestarting services ...\n"
service salt-master restart
[ -f /etc/salt/pki/minion/minion_master.pub ] && rm -f /etc/salt/pki/minion/minion_master.pub
service salt-minion restart
salt-call pillar.data > /dev/null 2>&1

echo -e "\nReclass metadata ...\n"
reclass --nodeinfo ${CONFIG_HOST}

echo -e "\nSalt grains metadata ...\n"
salt-call grains.items --no-color

echo -e "\nSalt pillar metadata ...\n"
salt-call pillar.data --no-color

echo -e "\nRunning necessary base states ...\n"
salt-call state.sls linux,openssh,salt.minion,salt.master.service --no-color

echo -e "\nRunning complete state ...\n"
salt-call state.highstate --no-color
