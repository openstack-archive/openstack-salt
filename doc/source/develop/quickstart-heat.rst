`Home <index.html>`_ OpenStack-Salt Development Documentation

OpenStack-Salt Heat deployment
==============================

All-in-one (AIO) deployments are a great way to setup an OpenStack-Salt cloud for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

It is possible to run full size proof-of-concept deployment on OpenStack with `Heat template`, the stack has following requirements for cluster deployment: 

* At least 200GB disk space
* 70GB RAM

The single-node deployment has following requirements:

* At least 80GB disk space
* 16GB RAM


Available Heat templates
------------------------

The `OpenStack-Salt heat templates repository`_ contains several repositories to help installing cloud deployments in OpenStack. We have prepared several basic deployment setups, summarised in the table below:

.. list-table::
   :stub-columns: 1

   *  - **HOT template**
      - **Description**
   *  - openstack_salt_ubuntu_single
      - Single-node OpenStack deployment on Ubuntu
   *  - openstack_salt_ubuntu_cluster
      - HA Cluster OpenStack deployment on Ubuntu
   *  - openstack_salt_redhat_single
      - Single-node OpenStack deployment on RedHat *EXPERIMENTAL*


Openstack-salt single setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This environment consists of three nodes.

.. list-table::
   :stub-columns: 1

   *  - **FQDN**
      - **Role**
      - **IP**
   *  - config.openstack.local
      - Salt master node
      - 10.10.10.200
   *  - control.openstack.local
      - OpenStack control node
      - 10.10.10.201
   *  - compute.openstack.local
      - OpenStack compute node
      - 10.10.10.202


Openstack-salt cluster setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This environment consists of six nodes.

.. list-table::
   :stub-columns: 1

   *  - **FQDN**
      - **Role**
      - **IP**
   *  - config.openstack.local
      - Salt master node
      - 10.10.10.200
   *  - control01.openstack.local
      - OpenStack control node
      - 10.10.10.201
   *  - control02.openstack.local
      - OpenStack control node
      - 10.10.10.202
   *  - control03.openstack.local
      - OpenStack control node
      - 10.10.10.203
   *  - compute01.openstack.local
      - OpenStack compute node
      - 10.10.10.211
   *  - compute02.openstack.local
      - OpenStack compute node
      - 10.10.10.212


Heat client setup
-----------------

The preffered way of installing OpenStack clients is isolated Python
environment. To creat Python environment and install compatible OpenStack
clients, you need to install build tools first.

On Ubuntu install:

.. code-block:: bash

   $ apt-get install python-dev python-pip python-virtualenv build-essential

Now create and activate virtualenv `venv-heat` so you can install specific
versions of OpenStack clients.

.. code-block:: bash

   $ virtualenv venv-heat
   $ source ./venv-heat/bin/activate

Use `requirements.txt` from the `OpenStack-Salt heat templates repository`_ to install
tested versions of clients into activated environment.

.. code-block:: bash

   $ pip install -r requirements.txt

The summary of clients for OpenStack. Following clients were tested with Juno and Kilo
Openstack versions.  

.. literalinclude:: ../../../scripts/requirements/heat.txt
   :language: python


If everything goes right, you should be able to use openstack clients, `heat`,
`nova`, etc.


Connecting to OpenStack cloud
-----------------------------

Setup OpenStack credentials so you can use openstack clients. You can
download ``openrc`` file from Openstack dashboard and source it or execute
following commands with filled credentials:

.. code-block:: bash

   $ vim ~/openrc

   export OS_AUTH_URL=https://<openstack_endpoint>:5000/v2.0
   export OS_USERNAME=<username>
   export OS_PASSWORD=<password>
   export OS_TENANT_NAME=<tenant>

Now source the OpenStack credentials:

.. code-block:: bash

   $ source openrc

To test your sourced variables:

.. code-block:: bash

   $ env | grep OS

Some resources required for heat environment deployment.

OpenStack networks 
~~~~~~~~~~~~~~~~~~

The public network is needed for setting up the ``salt_single`` heat stack. For further stacks, the salt_single network is needed. The network ID can be found in Openstack Dashboard or by running following command:


.. code-block:: bash

   $ neutron net-list


OpenStack images
~~~~~~~~~~~~~~~~

Ubuntu 14.04 LTS image is needed for OpenStack-Salt deployments, we recommend to download the latest `tcp cloud image`_. To lookup for actual installed images run:

.. code-block:: bash

   $ glance image-list


Launching the Heat stack
------------------------

Download heat templates from `OpenStack-Salt heat templates repository`_.

.. code-block:: bash

   $ git clone https://github.com/tcpcloud/heat-templates.git


Now you need to customize env files for stacks, see examples in env directory
and set required parameters.


``env/salt_single.env``:
    .. code-block:: yaml

       parameters:
         instance_image: <image_id>
         public_net_id: <net_id>
         # Public part of your SSH key and it's name
         key_name: my-key
         key_value: ssh-rsa xyz

``env/openstack_cluster_public.env``:
    .. code-block:: yaml

       parameters:
         instance_image: <image_id>
         private_net_id: <net_id>
         # Your SSH key, deployed by salt_single stack
         key_name: my-key

To see all available parameters, see template yaml files in `templates` directory.

Finally you can deploy common stack with Salt master, SSH key and private network.

.. code-block:: bash

   $ ./create_stack.sh salt_single

If everything goes right, stack should be ready in a few minutes. You can verify by running following commands:

.. code-block:: bash

   $ heat stack-list
   $ nova list

You should be also able to log in as root to public IP provided by ``nova list`` command.

Now you can deploy the actual OpenStack cluster:

.. code-block:: bash

   ./create_stack.sh openstack_cluster

When this cluster is deployed, you canlog in to the instances through the Salt master node.

.. _Heat template: https://github.com/tcpcloud/heat-templates
.. _OpenStack-Salt heat templates repository: https://github.com/tcpcloud/heat-templates
.. _tcp cloud image: http://apt.tcpcloud.eu/images/


Openstack-salt Hosting
----------------------

You can use publicly available labs offered by technology partners.  

Public lab at tcp cloud
~~~~~~~~~~~~~~~~~~~~~~~

Company tcp cloud has provided 100 cores and 400 GB of RAM divided in 5 separate projects, each with quotas set to 20 cores and 80 GB of RAM. Each project is capable of running both single and cluster deployments.

.. list-table::
   :stub-columns: 1

   *  - **Endpoint**
      - **User**
      - **Project**
      - **Domain**
   *  - https://cloudempire-api.tcpcloud.eu:35357/v2.0
      - openstack_salt_user01
      - openstack_salt_lab01
      - default
   *  - https://cloudempire-api.tcpcloud.eu:35357/v2.0
      - openstack_salt_user02
      - openstack_salt_lab02
      - default
   *  - https://cloudempire-api.tcpcloud.eu:35357/v2.0
      - openstack_salt_user03
      - openstack_salt_lab03
      - default
   *  - https://cloudempire-api.tcpcloud.eu:35357/v2.0
      - openstack_salt_user04
      - openstack_salt_lab04
      - default
   *  - https://cloudempire-api.tcpcloud.eu:35357/v2.0
      - openstack_salt_user05
      - openstack_salt_lab05
      - default

To get the access credentials and for support, visit ``#openstack-salt`` IRC channel.

--------------

.. include:: navigation.txt
