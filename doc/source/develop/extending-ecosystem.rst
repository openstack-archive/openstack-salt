`Home <index.html>`_ OpenStack-Salt Development Documentation

Formula ecosystem
=================

The OpenStack-Salt formulas are divided into several groups according to their purpose. Formulas share same structure and metadata definions, expose vital information into the Salt Mine for monitoring and audit.

* Infrastructure services
* Configuration services
* OpenStack services
* Monitoring services
* Integration services

Each of the service groups contain of several individual service formulas, listed in following tables.

Infrastructure services
-----------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - linux
      - https://github.com/tcpcloud/salt-formula-linux
   *  - freeipa
      - https://github.com/tcpcloud/salt-formula-freeipa
   *  - glusterfs
      - https://github.com/tcpcloud/salt-formula-glusterfs
   *  - iptables
      - https://github.com/tcpcloud/salt-formula-iptables
   *  - ntp
      - https://github.com/tcpcloud/salt-formula-ntp
   *  - openssh
      - https://github.com/tcpcloud/salt-formula-openssh

Configuration services
----------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - foreman
      - https://github.com/tcpcloud/salt-formula-foreman
   *  - maas
      - https://git.tcpcloud.eu/salt-formulas/maas-formula
   *  - reclass
      - https://github.com/tcpcloud/salt-formula-reclass
   *  - salt
      - https://github.com/tcpcloud/salt-formula-salt


Supplemental services
---------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - apache
      - https://github.com/tcpcloud/salt-formula-apache
   *  - bind
      - https://github.com/tcpcloud/salt-formula-bind
   *  - dovecot
      - https://github.com/tcpcloud/salt-formula-dovecot
   *  - elasticsearch
      - https://github.com/tcpcloud/salt-formula-elasticsearch
   *  - galera
      - https://github.com/tcpcloud/salt-formula-galera
   *  - git
      - https://github.com/tcpcloud/salt-formula-git
   *  - haproxy
      - https://github.com/tcpcloud/salt-formula-haproxy
   *  - keepalived
      - https://github.com/tcpcloud/salt-formula-keepalived
   *  - letsencrypt
      - https://github.com/tcpcloud/salt-formula-letsencrypt
   *  - memcached
      - https://github.com/tcpcloud/salt-formula-memcached
   *  - mongodb
      - https://github.com/tcpcloud/salt-formula-mongodb
   *  - mysql
      - https://github.com/tcpcloud/salt-formula-mysql
   *  - nginx
      - https://github.com/tcpcloud/salt-formula-nginx
   *  - postfix
      - https://github.com/tcpcloud/salt-formula-postfix
   *  - postgresql
      - https://github.com/tcpcloud/salt-formula-postgresql
   *  - rabbitmq
      - https://github.com/tcpcloud/salt-formula-rabbitmq
   *  - redis
      - https://github.com/tcpcloud/salt-formula-redis
   *  - supervisor
      - https://github.com/tcpcloud/salt-formula-supervisor
   *  - varnish
      - https://github.com/tcpcloud/salt-formula-varnish


OpenStack services
------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - ceilometer
      - https://github.com/openstack/salt-formula-ceilometer
   *  - cinder
      - https://github.com/openstack/salt-formula-cinder
   *  - glance
      - https://github.com/openstack/salt-formula-glance
   *  - heat
      - https://github.com/openstack/salt-formula-heat
   *  - horizon
      - https://github.com/openstack/salt-formula-horizon
   *  - keystone
      - https://github.com/openstack/salt-formula-keystone
   *  - magnum
      - https://github.com/tcpcloud/salt-formula-keystone
   *  - murano
      - https://github.com/tcpcloud/salt-formula-keystone
   *  - neutron
      - https://github.com/openstack/salt-formula-neutron
   *  - nova
      - https://github.com/openstack/salt-formula-nova
   *  - opencontrail
      - https://github.com/openstack/salt-formula-opencontrail


Monitoring services
-------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - collectd
      - https://github.com/tcpcloud/salt-formula-collectd
   *  - graphite
      - https://github.com/tcpcloud/salt-formula-graphite
   *  - heka
      - https://github.com/tcpcloud/salt-formula-heka
   *  - kibana
      - https://github.com/tcpcloud/salt-formula-kibana
   *  - sensu
      - https://github.com/tcpcloud/salt-formula-sensu
   *  - sphinx
      - https://github.com/tcpcloud/salt-formula-sphinx
   *  - statsd
      - https://github.com/tcpcloud/salt-formula-sensu

Integration services
--------------------

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - aptly
      - https://github.com/tcpcloud/salt-formula-aptly
   *  - gerrit
      - https://git.tcpcloud.eu/salt-formulas/gerrit-formula
   *  - gitlab
      - https://github.com/tcpcloud/salt-formula-gitlab
   *  - jenkins
      - https://github.com/tcpcloud/salt-formula-jenkins
   *  - owncloud
      - https://github.com/tcpcloud/salt-formula-owncloud
   *  - roundcube
      - https://github.com/tcpcloud/salt-formula-roundcube


--------------

.. include:: navigation.txt
