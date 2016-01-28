`Home <index.html>`_ OpenStack-Salt Development Documentation

OpenStack-Salt AIO Vagrant deployment
=====================================

All-in-one (AIO) deployments are a great way to setup an OpenStack-Salt cloud for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

Although AIO builds aren't suitable for large production deployments, they're great for small proof-of-concept deployments.

It's strongly recommended to have hardware that meets the following requirements before starting an AIO deployment:

* CPU with `hardware-assisted virtualization`_ support
* At least 80GB disk space
* 8GB RAM

Vagrant setup
-------------

Installing Vagrant is extremely easy for many operating systems. Go to the `Vagrant downloads page`_ and get the appropriate installer or package for your platform. Install the package using standard procedures for your operating system.

The installer will automatically add vagrant to your system path so that it is available in shell. Try logging out and logging back in to your system (this is particularly necessary sometimes for Windows) to get the updated system path up and running.

First we will install vagrant-salt plugin for minion configuration.

.. code-block:: bash

   $ vagrant plugin install vagrant-salt

Add the generic ubuntu1404 image for virtualbox virtualization.

.. code-block:: bash

    $ vagrant box add ubuntu/trusty64

    ==> box: Loading metadata for box 'ubuntu/trusty64'
        box: URL: https://atlas.hashicorp.com/ubuntu/trusty64
    ==> box: Adding box 'ubuntu/trusty64' (v20160122.0.0) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20160122.0.0/providers/virtualbox.box
    ==> box: Successfully added box 'ubuntu/trusty64' (v20160122.0.0) for 'virtualbox'!


Environment setup 
-----------------

The environment consists of 3 nodes:

* config: Salt master node, IP: 10.10.10.200
* control: OpenStack control node, IP: 10.10.10.201
* compute: OpenStack compute node, IP: 10.10.10.202


Minion configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~

Prepare basic configuration files for each node deployed.

Set ``/srv/vagrant-openstack/config.conf`` to following:

.. literalinclude:: ../../../scripts/vagrant-openstack/config.conf
   :language: yaml

Set ``/srv/vagrant-openstack/control.conf`` to following:

.. literalinclude:: ../../../scripts/vagrant-openstack/control.conf
   :language: yaml

Set ``/srv/vagrant-openstack/compute.conf`` to following content:

.. literalinclude:: ../../../scripts/vagrant-openstack/compute.conf
   :language: yaml


Vagrant configuration file
~~~~~~~~~~~~~~~~~~~~~~~~~~

The main vagrant configuration for OpenStack-Salt deployment is located at ``/srv/vagrant-openstack/Vagrantfile``.

.. literalinclude:: ../../../scripts/vagrant-openstack/Vagrantfile
   :language: ruby


Salt master bootstrap file
~~~~~~~~~~~~~~~~~~~~~~~~~~

The salt-master bootstrap is located at ``/srv/vagrant-openstack/bootstrap-salt-master.sh`` and it needs to be placed at the vagrant-openstack folder to be accessible from the virtual machine.

.. literalinclude:: ../../../scripts/vagrant-openstack/bootstrap-salt-master.sh
   :language: bash


Launching the Vagrant nodes
---------------------------

Check the status of the deployment environment.

.. code-block:: bash

    $ cd /srv/vagrant-openstack
    $ vagrant status
    
    Current machine states:

    openstack_config          not created (virtualbox)
    openstack_control         not created (virtualbox)
    openstack_compute         not created (virtualbox)

Setup OpenStack-Salt config node, launch it and connect to it using following commands:

.. code-block:: bash

    $ vagrant up openstack_config
    $ vagrant ssh openstack_config

Bootstrap the salt master service on the config node, configure it with following parameters.

.. code-block:: bash

    $ cd /vagrant

    $ export RECLASS_ADDRESS=https://github.com/tcpcloud/workshop-salt-model.git
    $ export CONFIG_HOST=config.openstack.local

    $ bash bootstrap-salt-master.sh

Now setup th OpenStack-Salt control node. Launch the control node using following vagrant command:

.. code-block:: bash

    $ vagrant up openstack_control
    $ vagrant provision openstack_control

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
.. _Vagrant downloads page: https://www.vagrantup.com/downloads.html
