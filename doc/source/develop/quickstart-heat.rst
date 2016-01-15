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


List of available stacks
-------------------------

.. list-table::
   :stub-columns: 1

   *  - salt_single_public
      - Base stack which deploys network and single-node Salt master
   *  - openstack_cluster_public
      - Deploy OpenStack cluster with OpenContrail, requires
        ``salt_single_public``


Launching the Heat stack
------------------------

#. Setup environment file, eg. ``env/salt_single_public.env``, look at example
   file first
#. Source credentials and required environment variables. You can download
   openrc file from Horizon dashboard.

   .. code-block:: bash

     source my_tenant-openrc.sh

#. Deploy the actual stack

   .. code-block:: bash

     ./create_stack.sh salt_single_public
