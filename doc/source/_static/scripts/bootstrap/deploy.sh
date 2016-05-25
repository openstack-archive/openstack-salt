#!/bin/bash

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
