#!/bin/bash

FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas}
FORMULA_BRANCH=${FORMULA_BRANCH:-master}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}

echo "Configuring necessary formulas ..."

[ ! -d /srv/salt/reclass/classes/service ] && mkdir -p /srv/salt/reclass/classes/service

declare -a FORMULA_SERVICES=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx")

for FORMULA_SERVICE in "${FORMULA_SERVICES[@]}"; do
    echo -e "\nConfiguring salt formula ${FORMULA_SERVICE} ...\n"
    [ ! -d "${FORMULA_PATH}/env/_formulas/${FORMULA_SERVICE}" ] && \
        git clone https://github.com/tcpcloud/salt-formula-${FORMULA_SERVICE}.git ${FORMULA_PATH}/env/_formulas/${FORMULA_SERVICE} -b ${FORMULA_BRANCH}
    [ ! -L "/usr/share/salt-formulas/env/${FORMULA_SERVICE}" ] && \
        ln -s ${FORMULA_PATH}/env/_formulas/${FORMULA_SERVICE}/${FORMULA_SERVICE} /usr/share/salt-formulas/env/${FORMULA_SERVICE}
    [ ! -L "/srv/salt/reclass/classes/service/${FORMULA_SERVICE}" ] && \
        ln -s ${FORMULA_PATH}/env/_formulas/${FORMULA_SERVICE}/metadata/service /srv/salt/reclass/classes/service/${FORMULA_SERVICE}
done

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
[ ! -L /srv/salt/env/dev ] && ln -s /usr/share/salt-formulas/env /srv/salt/env/dev
