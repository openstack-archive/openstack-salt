
Troubleshooting database
============================

MySQL Galera
************

MySQL galera cluster status can be verifed through following command:

.. code-block:: bash

        root@ctl01:~# mysql -uroot -pXXXX -e "show status;"
        ...
        | wsrep_local_state_comment                | Synced                                             |
        | wsrep_cert_index_size                    | 41                                                 |
        | wsrep_causal_reads                       | 0                                                  |
        | wsrep_incoming_addresses                 | 10.0.106.72:3306,10.0.106.73:3306,10.0.106.71:3306 |
        | wsrep_cluster_conf_id                    | 29                                                 |
        | wsrep_cluster_size                       | 3                                                  |
        ...

Rejoining one node
------------------

MySQL Galera is build from 3 nodes. Failure one of node does not cause any outage of database and should be solved by restarting mysql service. If node cannot be rejoined back to cluster, there must be removed several files:

.. code-block:: bash

        rm -rf /var/lib/mysql/grastate*
        rm -rf /var/lib/mysql/ib_log*
        service mysql start


Restarting whole cluster
------------------------

In case of outage all three mysql cluster nodes, it must be started with specific order and parameters. At first check that all mysql proceses at all nodes are killed.

**Node 1** - configure wsrep_cluster_address without any ip addresses and start mysql

.. code-block:: bash
        
        vim /etc/mysql/my.cnf
        ....
        wsrep_cluster_address=gcomm://
        ....

        service mysql start

**Node 2** and **Node 3**

.. code-block:: bash
        
        rm -rf /var/lib/mysql/grastate*
        rm -rf /var/lib/mysql/ib_log*
        service mysql start

--------------

.. include:: navigation.txt
