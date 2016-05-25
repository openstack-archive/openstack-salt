#!/bin/bash

OS_DISTRIBUTION=${OS_DISTRIBUTION:-ubuntu}
OS_NETWORKING=${OS_NETWORKING:-opencontrail}
OS_DEPLOYMENT=${OS_DEPLOYMENT:-single}
OS_SYSTEM="${OS_DISTRIBUTION}_${OS_NETWORKING}_${OS_DEPLOYMENT}"

SALT_SOURCE=${SALT_SOURCE:-pip}
SALT_VERSION=${SALT_VERSION:-latest}

if [ "$FORMULA_SOURCE" == "git" ]; then
  SALT_ENV="dev"
elif [ "$FORMULA_SOURCE" == "pkg" ]; then
  SALT_ENV="prd"
fi

FORMULA_SOURCE=${FORMULA_SOURCE:-git}

RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/openstack-salt-model.git}
RECLASS_BRANCH=${RECLASS_BRANCH:-master}
RECLASS_SYSTEM=${RECLASS_SYSTEM:-$OS_SYSTEM}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}
CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}

echo -e "\nPreparing base OS repository ...\n"

echo -e "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

echo -e "\nInstalling salt master ...\n"

if [ -x "`which invoke-rc.d 2>/dev/null`" -a -x "/etc/init.d/salt-minion" ] ; then
  apt-get purge -y salt-minion salt-common && apt-get autoremove -y
fi

apt-get install -y python-pip python-dev zlib1g-dev reclass git

if [ "$SALT_VERSION" == "latest" ]; then
  pip install salt
else
  pip install salt==$SALT_VERSION
fi

wget -O /etc/init.d/salt-master https://anonscm.debian.org/cgit/pkg-salt/salt.git/plain/debian/salt-master.init && chmod 755 /etc/init.d/salt-master
ln -s /usr/local/bin/salt-master /usr/bin/salt-master

[ ! -d /etc/salt/master.d ] && mkdir -p /etc/salt/master.d

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

wget -O /etc/init.d/salt-minion https://anonscm.debian.org/cgit/pkg-salt/salt.git/plain/debian/salt-minion.init && chmod 755 /etc/init.d/salt-minion
ln -s /usr/local/bin/salt-minion /usr/bin/salt-minion

[ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d

echo -e "master: 127.0.0.1\nid: $CONFIG_HOST" > /etc/salt/minion.d/minion.conf

echo "Configuring reclass ..."

[ ! -d /etc/reclass ] && mkdir /etc/reclass
cat << 'EOF' > /etc/reclass/reclass-config.yml
storage_type: yaml_fs
pretty_print: True
output: yaml
inventory_base_uri: /srv/salt/reclass
EOF

git clone ${RECLASS_ADDRESS} /srv/salt/reclass -b ${RECLASS_BRANCH}

if [ ! -f "/srv/salt/reclass/nodes/${CONFIG_HOST}.yml" ]; then

cat << EOF > /srv/salt/reclass/nodes/${CONFIG_HOST}.yml
classes:
- service.git.client
- system.linux.system.single
- system.openssh.client.workshop
- system.salt.master.single
- system.salt.master.formula.$FORMULA_SOURCE
- system.reclass.storage.salt
- system.reclass.storage.system.$RECLASS_SYSTEM
parameters:
  _param:
    reclass_data_repository: "$RECLASS_ADDRESS"
    reclass_data_revision: $RECLASS_BRANCH
    salt_formula_branch: $FORMULA_BRANCH
    reclass_config_master: $CONFIG_ADDRESS
    single_address: $CONFIG_ADDRESS
    salt_master_host: 127.0.0.1
    salt_master_base_environment: $SALT_ENV
  linux:
    system:
      name: $CONFIG_HOSTNAME
      domain: $CONFIG_DOMAIN
EOF

if [ "$SALT_VERSION" == "latest" ]; then

cat << EOF >> /srv/salt/reclass/nodes/${CONFIG_HOST}.yml
  salt:
    master:
      accept_policy: open_mode
      source:
        engine: $SALT_SOURCE
    minion:
      source:
        engine: $SALT_SOURCE
EOF

else

cat << EOF >> /srv/salt/reclass/nodes/${CONFIG_HOST}.yml
  salt:
    master:
      accept_policy: open_mode
      source:
        engine: $SALT_SOURCE
        version: $SALT_VERSION
    minion:
      source:
        engine: $SALT_SOURCE
        version: $SALT_VERSION
EOF

fi

fi
