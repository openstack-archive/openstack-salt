#!/bin/bash

SALT_VERSION=${SALT_VERSION:-latest}

CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}
MINION_MASTER=${MINION_MASTER:-$CONFIG_ADDRESS}
MINION_ID=${MINION_ID:-minion}

echo -e "\nPreparing base OS repository ...\n"

echo -e "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

echo -e "\nInstalling salt minion ...\n"

if [ "$SALT_VERSION" == "latest" ]; then
  apt-get install -y salt-common salt-minion
else
  apt-get install -y --force-yes salt-common=$SALT_VERSION salt-minion=$SALT_VERSION
fi

[ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d

echo -e "master: $MINION_MASTER\nid: $MINION_ID" > /etc/salt/minion.d/minion.conf
