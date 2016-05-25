#!/bin/bash

FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas}
FORMULA_ADDRESS=${FORMULA_ADDRESS:-deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty tcp-salt}
FORMULA_GPG=${FORMULA_GPG:-http://apt.tcpcloud.eu/public.gpg}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}
CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}

echo "Configuring necessary formulas ..."
which wget > /dev/null || (apt-get update; apt-get install -y wget)

echo "${FORMULA_ADDRESS}" > /etc/apt/sources.list.d/salt-formulas.list
wget -O - "${FORMULA_GPG}" | apt-key add -

apt-get clean
apt-get update

[ ! -d /srv/salt/reclass/classes/service ] && mkdir -p /srv/salt/reclass/classes/service

declare -a formula_services=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx")

for formula_service in "${formula_services[@]}"; do
    echo -e "\nConfiguring salt formula ${formula_service} ...\n"
    [ ! -d "${FORMULA_PATH}/env/${formula_service}" ] && \
        apt-get install -y salt-formula-${formula_service}
    [ ! -L "/srv/salt/reclass/classes/service/${formula_service}" ] && \
        ln -s ${FORMULA_PATH}/reclass/service/${formula_service} /srv/salt/reclass/classes/service/${formula_service}
done

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
[ ! -L /srv/salt/env/prd ] && ln -s ${FORMULA_PATH}/env /srv/salt/env/prd
