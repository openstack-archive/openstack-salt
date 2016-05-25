#!/bin/bash

OS_DISTRIBUTION=${OS_DISTRIBUTION:-ubuntu}
OS_NETWORKING=${OS_NETWORKING:-opencontrail}
OS_DEPLOYMENT=${OS_DEPLOYMENT:-single}
OS_SYSTEM="${OS_DISTRIBUTION}_${OS_NETWORKING}_${OS_DEPLOYMENT}"

SALT_SOURCE=${SALT_SOURCE:-pkg}
SALT_VERSION=${SALT_VERSION:-latest}

FORMULA_SOURCE=${FORMULA_SOURCE:-git}
FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas}
FORMULA_BRANCH=${FORMULA_BRANCH:-master}

if [ "$FORMULA_SOURCE" == "git" ]; then
  SALT_ENV="dev"
elif [ "$FORMULA_SOURCE" == "pkg" ]; then
  SALT_ENV="prd"
fi

RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/openstack-salt-model.git}
RECLASS_BRANCH=${RECLASS_BRANCH:-master}
RECLASS_SYSTEM=${RECLASS_SYSTEM:-$OS_SYSTEM}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}
CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}

[ ! -d /root/deploy-scripts ] && mkdir /root/deploy-scripts

source "./salt-master-${SALT_SOURCE}.sh"

source "./salt-formula-${FORMULA_SOURCE}.sh"

source "./deploy.sh"
