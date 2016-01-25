`Home <index.html>`_ OpenStack-Salt Development Documentation

Heat Stack deployment
=====================

All-in-one (AIO) deployments are a great way to setup an OpenStack-Salt cloud for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

It is possible to run full size proof-of-concept deployment on OpenStack with `Heat template`, the stack has following requirements: 

* At least 200GB disk space
* 70GB RAM

.. _Heat template: https://github.com/tcpcloud/heat-templates


List of available stacks
------------------------

.. list-table::
   :stub-columns: 1

   *  - salt_single_public
      - Base stack which deploys network and single-node Salt master
   *  - openstack_cluster_public
      - Deploy OpenStack cluster with OpenContrail, requires
        ``salt_single_public``

Heat client setup
-----------------

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


Environment setup 
-----------------

To install heat client, it's recommended to setup Python virtualenv and
install tested versions of openstack clients that are defined in
`requirements.txt` file.

Install build tools (eg. on Ubuntu):
  .. code-block:: bash

     apt-get install python-dev python-pip python-virtualenv build-essential libffi-dev libssl-dev

Create and activate virtualenv named `venv-heat`:
  .. code-block:: bash

     virtualenv venv-heat
     source ./venv-heat/bin/activate

Install requirements:
  .. code-block:: bash

     pip install -r requirements.txt


Launching the Heat stack
------------------------

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

To see all available parameters, see template yaml files in `templates` directory.

Finally you can deploy common stack with Salt master, SSH key and private network.

.. code-block:: bash

   ./create_stack.sh salt_single_public

If everything goes right, stack should be ready in a few minutes. You can verify by running following commands:

.. code-block:: bash

   heat stack-list
   nova list

You should be also able to log in as root to public IP provided by ``nova list`` command.

Now you can deploy openstack cluster:

.. code-block:: bash

   ./create_stack.sh openstack_cluster_public

When cluster is deployed, you should be able to log in to the instances from Salt master node by forwarding your SSH agent.
