OpenStack over OpenStack Heat deployment
===========================================

This procedure enables to launch salt-openstack iside of existing OpenStack deployment as Heat template.

Heat stacks
~~~~~~~~~~~~~~~~~~~~

Lab setup consists of multiple Heat stacks.

.. list-table::
   :stub-columns: 1

   *  - salt_single_public
      - Base stack which deploys network and single-node Salt master
   *  - openstack_cluster_public
      - Deploy OpenStack cluster with OpenContrail, requires
        ``salt_single_public``
   *  - openvstorage_cluster_private
      - Deploy Open vStorage infrastructure on top of
        ``openstack_cluster_public``

Naming convention is following:

::

    <name>_<cluster|single>_<public|private>

* `name` is short identifier describing main purpose of given stack
* `cluster` or `single` identifies topology (multi node vs. single node setup)
* `public` or `private` identifies network access. Public sets security group
  and assigns floating IP so provided services are visible from outside world.

For smallest clustered setup, we are going to use `salt_single_public` and
`openstack_cluster_public` stacks.

Heat client
~~~~~~~~~~~~~~~~~~~~

First you need to clone heat templates from our `Github repository
<https://github.com/tcpcloud/heat-templates>`_.

.. code-block:: bash

   git clone https://github.com/tcpcloud/heat-templates.git

To be able to create Python environment and install compatible OpenStack
clients, you need to install build tools first. Eg. on Ubuntu:

.. code-block:: bash

   apt-get install python-dev python-pip python-virtualenv build-essential

Now create and activate virtualenv `venv-heat` so you can install specific
versions of OpenStack clients into completely isolated Python environment.

.. code-block:: bash

   virtualenv venv-heat
   source ./venv-heat/bin/activate

To install tested versions of clients for OpenStack Juno and Kilo into
activated environment, use `requirements.txt` file in repository cloned
earlier:

.. code-block:: bash

   pip install -r requirements.txt

If everything goes right, you should be able to use openstack clients, `heat`,
`nova`, etc.

Stack deployment
~~~~~~~~~~~~~~~~~~~~

First source openrc credentials so you can use openstack clients. You can
download openrc file from Openstack dashboard and source it or execute
following commands with filled credentials:

.. code-block:: bash

   export OS_AUTH_URL=https://<openstack_endpoint>:5000/v2.0
   export OS_USERNAME=<username>
   export OS_PASSWORD=<password>
   export OS_TENANT_NAME=<tenant>

Now you need to customize env files for stacks, see examples in env directory
and set required parameters.

``env/salt_single_public.env``:
    .. code-block:: yaml

       parameters:
         # Following parameters are required to deploy workshop lab environment
         # Public net id can be found in Horizon or by running `nova net-list`
         public_net_id: f82ffadb-cd7b-4931-a2c1-f865c61edef2
         # Public part of your SSH key
         key_name: my-key
         key_value: ssh-rsa xyz
         # Instance image to use, we recommend to grab latest tcp cloud image here:
         # http://apt.tcpcloud.eu/images/
         # Lookup for image by running `nova image-list`
         instance_image: ubuntu-14-04-x64-1437486976

``env/openstack_cluster_public.env``:
    .. code-block:: yaml

       parameters:
         # Following parameters are required to deploy workshop lab environment
         # Net id can be found in Horizon or by running `nova net-list`
         public_net_id: f82ffadb-cd7b-4931-a2c1-f865c61edef2
         private_net_id: 90699bd2-b10e-4596-99c6-197ac3fb565a
         # Your SSH key, deployed by salt_single_public stack
         key_name: my-key
         # Instance image to use, we recommend to grab latest tcp cloud image here:
         # http://apt.tcpcloud.eu/images/
         # Lookup for image by running `nova image-list`
         instance_image: ubuntu-14-04-x64-1437486976

To see all available parameters, see template yaml files in `templates`
directory.

Finally you can deploy common stack with Salt master, SSH key and private network.

.. code-block:: bash

   ./create_stack.sh salt_single_public

If everything goes right, stack should be ready in a few minutes. You can
verify by running following commands:

.. code-block:: bash

   heat stack-list
   nova list

You should be also able to log in as root to public IP provided by ``nova
list`` command.

Now you can deploy openstack cluster:

.. code-block:: bash

   ./create_stack.sh openstack_cluster_public

When cluster is deployed, you should be able to log in to the instances
from Salt master node by forwarding your SSH agent.

Deploy Salt master
~~~~~~~~~~~~~~~~~~~~

Login to cfg01 node and run highstate to ensure everything is set up
correctly.

.. code-block:: bash

   salt-call state.highstate

Then you should be able to see all Salt minions.

.. code-block:: bash

   salt '*' grains.get ipv4

Deploy control nodes
~~~~~~~~~~~~~~~~~~~~

First execute basic states on all nodes to ensure Salt minion, system and
OpenSSH are set up.

.. code-block:: bash

   salt '*' state.sls linux,salt,openssh,ntp

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

Verification
^^^^^^^^^^^^^^^^

Everything should be up and running now. You should execute a few checks
before continue.
Execute following checks on one or all control nodes.

Check GlusterFS status:
    .. code-block:: bash

       gluster peer status
       gluster volume status

Check Galera status (execute on one of the controllers):
    .. code-block:: bash

       mysql -pworkshop -e'SHOW STATUS;'

Check OpenContrail status:
    .. code-block:: bash

       contrail-status

Check OpenStack services:
    .. code-block:: bash

       nova-manage service list
       cinder-manage service list

Source keystone credentials and try Nova API:
    .. code-block:: bash

       source keystonerc
       nova list

Deploy compute nodes
~~~~~~~~~~~~~~~~~~~~~

Simply run highstate (better twice):

.. code-block:: bash

   salt 'cmp*' state.highstate
   
Dashboard and support infrastructure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Web and metering nodes can be deployed by running highstate:

.. code-block:: bash

   salt 'web*' state.highstate
   salt 'mtr*' state.highstate

On monitoring node, you need to setup git first:

.. code-block:: bash

   salt 'mon*' state.sls git
   salt 'mon*' state.highstate

--------------

.. include:: navigation.txt