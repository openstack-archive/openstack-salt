
Troubleshooting networking
============================

OpenContrail
************

Contrail-status provides information status of all contrail services. All of them should be active except contrail-device-manager, contrail-schema and contrail-svc-monitor. These can be in active state at only one node in cluster. It is dynamically switched in case of failure.

.. code-block:: bash

        root@ctl01:~# contrail-status

        == Contrail Control ==
        supervisor-control:           active
        contrail-control              active              
        contrail-control-nodemgr      active              
        contrail-dns                  active              
        contrail-named                active              

        == Contrail Analytics ==
        supervisor-analytics:         active
        contrail-analytics-api        active              
        contrail-analytics-nodemgr    active              
        contrail-collector            active              
        contrail-query-engine         active              
        contrail-snmp-collector       active              
        contrail-topology             active              

        == Contrail Config ==
        supervisor-config:            active
        contrail-api:0                active              
        contrail-config-nodemgr       active              
        contrail-device-manager       initializing        
        contrail-discovery:0          active              
        contrail-schema               initializing        
        contrail-svc-monitor          initializing        
        ifmap                         active              

        == Contrail Web UI ==
        supervisor-webui:             active
        contrail-webui                active              
        contrail-webui-middleware     active              

        == Contrail Database ==
        supervisor-database:          active
        contrail-database             active              
        contrail-database-nodemgr     active              

        == Contrail Support Services ==
        supervisor-support-service:   active
        rabbitmq-server               active 

OpenContrail uses for all services python daemon supervisord, which create logical groups from specific services. It is automaticaly installed with contrail packages.

* supervisor-support-service
* supervisor-openstack
* supervisor-database
* supervisor-config
* supervisor-analytics
* supervisor-control
* supervisor-webui

Services can be restarted as whole supervisor

.. code-block:: bash

        service supervisor-openstack restart

or as individual services inside of supervisor

.. code-block:: bash

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_support_service.sock status
        rabbitmq-server                  RUNNING    pid 1335, uptime 2 days, 21:11:55

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_openstack.sock status
        cinder-api                       RUNNING    pid 57685, uptime 2 days, 0:10:39
        cinder-scheduler                 RUNNING    pid 57675, uptime 2 days, 0:10:44
        glance-api                       RUNNING    pid 9317, uptime 2 days, 21:08:52
        glance-registry                  RUNNING    pid 9352, uptime 2 days, 21:08:51
        heat-api                         RUNNING    pid 9393, uptime 2 days, 21:08:50
        heat-engine                      RUNNING    pid 9351, uptime 2 days, 21:08:51
        keystone                         RUNNING    pid 9325, uptime 2 days, 21:08:52
        nova-api                         RUNNING    pid 9339, uptime 2 days, 21:08:51
        nova-conductor                   RUNNING    pid 9300, uptime 2 days, 21:08:53
        nova-console                     RUNNING    pid 9330, uptime 2 days, 21:08:52
        nova-consoleauth                 RUNNING    pid 9319, uptime 2 days, 21:08:52
        nova-novncproxy                  RUNNING    pid 9299, uptime 2 days, 21:08:53
        nova-objectstore                 RUNNING    pid 9321, uptime 2 days, 21:08:52
        nova-scheduler                   RUNNING    pid 9344, uptime 2 days, 21:08:51

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_database.sock status
        contrail-database                RUNNING    pid 1349, uptime 2 days, 21:12:33
        contrail-database-nodemgr        RUNNING    pid 1347, uptime 2 days, 21:12:33

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_config.sock status
        contrail-api:0                   RUNNING    pid 49848, uptime 2 days, 20:11:54
        contrail-config-nodemgr          RUNNING    pid 49845, uptime 2 days, 20:11:54
        contrail-device-manager          RUNNING    pid 49849, uptime 2 days, 20:11:54
        contrail-discovery:0             RUNNING    pid 49847, uptime 2 days, 20:11:54
        contrail-schema                  RUNNING    pid 49850, uptime 2 days, 20:11:54
        contrail-svc-monitor             RUNNING    pid 49851, uptime 2 days, 20:11:54
        ifmap                            RUNNING    pid 49846, uptime 2 days, 20:11:54

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_config.sock status
        contrail-api:0                   RUNNING    pid 49848, uptime 2 days, 20:12:08
        contrail-config-nodemgr          RUNNING    pid 49845, uptime 2 days, 20:12:08
        contrail-device-manager          RUNNING    pid 49849, uptime 2 days, 20:12:08
        contrail-discovery:0             RUNNING    pid 49847, uptime 2 days, 20:12:08
        contrail-schema                  RUNNING    pid 49850, uptime 2 days, 20:12:08
        contrail-svc-monitor             RUNNING    pid 49851, uptime 2 days, 20:12:08
        ifmap                            RUNNING    pid 49846, uptime 2 days, 20:12:08

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_analytics.sock status                                                                                                                  
        contrail-analytics-api           RUNNING    pid 1346, uptime 2 days, 21:13:17
        contrail-analytics-nodemgr       RUNNING    pid 1340, uptime 2 days, 21:13:17
        contrail-collector               RUNNING    pid 1344, uptime 2 days, 21:13:17
        contrail-query-engine            RUNNING    pid 1345, uptime 2 days, 21:13:17
        contrail-snmp-collector          RUNNING    pid 1341, uptime 2 days, 21:13:17
        contrail-topology                RUNNING    pid 1343, uptime 2 days, 21:13:17

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_control.sock status
        contrail-control                 RUNNING    pid 1330, uptime 2 days, 21:13:29
        contrail-control-nodemgr         RUNNING    pid 1328, uptime 2 days, 21:13:29
        contrail-dns                     RUNNING    pid 1331, uptime 2 days, 21:13:29
        contrail-named                   RUNNING    pid 1333, uptime 2 days, 21:13:29

        root@ctl01:~# supervisorctl -s unix:///tmp/supervisord_webui.sock status
        contrail-webui                   RUNNING    pid 1339, uptime 2 days, 21:13:44
        contrail-webui-middleware        RUNNING    pid 1342, uptime 2 days, 21:13:44

--------------

.. include:: navigation.txt
