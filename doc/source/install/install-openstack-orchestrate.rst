
Orchestrate OpenStack services
================================

Control nodes deployment
-------------------------

Next you can deploy basic services:

* keepalived - this service will set up virtual IP on controllers
* rabbitmq
* GlusterFS server service

.. code-block:: bash

   salt 'ctl*' state.sls keepalived,rabbitmq,glusterfs.server.service

Now you can deploy Galera MySQL and GlusterFS cluster node by node.

.. code-block:: bash

   salt 'ctl01*' state.sls glusterfs.server,galera
   salt 'ctl02*' state.sls glusterfs.server,galera
   salt 'ctl03*' state.sls glusterfs.server,galera

Next you need to ensure that GlusterFS is mounted. Permission errors are ok at
this point, because some users and groups does not exist yet.

.. code-block:: bash

   salt 'ctl*' state.sls glusterfs.client

Finally you can execute highstate to deploy remaining services. Again, run
this node by node.

.. code-block:: bash

   salt 'ctl01*' state.highstate
   salt 'ctl02*' state.highstate
   salt 'ctl03*' state.highstate


Compute nodes deployment
~~~~~~~~~~~~~~~~~~~~~~~~

Simply run highstate (better twice):

.. code-block:: bash

   salt 'cmp*' state.highstate
   
Dashboard and support infrastructure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Web and metering nodes can be deployed by running highstate:

.. code-block:: bash

   salt 'web*' state.highstate
   salt 'mtr*' state.highstate

On monitoring node, get needs to setup first:

.. code-block:: bash

   salt 'mon*' state.sls git
   salt 'mon*' state.highstate

--------------

.. include:: navigation.txt
