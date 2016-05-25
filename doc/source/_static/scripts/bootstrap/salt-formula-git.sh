#!/bin/bash -x

CONFIG_HOST=${CONFIG_HOST:-config.openstack.local}
FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas/env/_formulas}
FORMULA_BRANCH=${FORMULA_BRANCH:-master}
RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/workshop-salt-model.git}
RECLASS_BRANCH=${RECLASS_BRANCH:-master}

declare -a FORMULA_SERVICES=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx")

[ ! -d /srv/salt/env ] && mkdir -p /srv/salt/env
[ ! -e "/srv/salt/env/dev" ] && ln -s /usr/share/salt-formulas/env /srv/salt/env/dev

for FORMULA_SERVICE in "${FORMULA_SERVICES[@]}"
do
    printf "\nConfiguring salt formula ${FORMULA_SERVICE} ...\n"
    [ ! -d "${FORMULA_PATH}/${FORMULA_SERVICE}" ] && \
        git clone "https://github.com/tcpcloud/salt-formula-${FORMULA_SERVICE}.git" "${FORMULA_PATH}/${FORMULA_SERVICE}" -b ${FORMULA_BRANCH}
    [ ! -e "/usr/share/salt-formulas/env/${FORMULA_SERVICE}" ] && \
        ln -s "${FORMULA_PATH}/${FORMULA_SERVICE}/${FORMULA_SERVICE}" "/usr/share/salt-formulas/env/${FORMULA_SERVICE}"
    [ ! -e "/srv/salt/reclass/classes/service/${FORMULA_SERVICE}" ] && \
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
