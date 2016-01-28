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

Add the generic ubuntu1404 image, this applies for parallels, virtualbox and vmware_desktop virtualizations.

.. code-block:: bash

	$ vagrant box add boxcutter/ubuntu1404

	==> box: Loading metadata for box 'boxcutter/ubuntu1404'
	    box: URL: https://atlas.hashicorp.com/boxcutter/ubuntu1404
	This box can work with multiple providers! The providers that it
	can work with are listed below. Please review the list and choose
	the provider you will be working with.

	1) parallels
	2) virtualbox
	3) vmware_desktop

	$ Enter your choice: 2

	==> box: Adding box 'boxcutter/ubuntu1404' (v2.0.13) for provider: virtualbox
	    box: Downloading: https://atlas.hashicorp.com/boxcutter/boxes/ubuntu1404/versions/2.0.13/providers/virtualbox.box
	==> box: Successfully added box 'boxcutter/ubuntu1404' (v2.0.13) for 'virtualbox'!

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

Tve main vagrant configuration for OpenStack-Salt deployment is located at ``/srv/vagrant-openstack/Vagrantfile``.

.. literalinclude:: ../../../scripts/vagrant-openstack/Vagrantfile
   :language: ruby
   :linenos:

Launching the Vagrant nodes
---------------------------

Check the configuration of the deployment

.. code-block:: bash

    $ cd /srv/vagrant-openstack
    $ vagrant status
    
    Current machine states:

    openstack_config          not created (virtualbox)
    openstack_control         not created (virtualbox)
    openstack_compute         not created (virtualbox)

First we setup openstack config node. Launch the node using vagrant command:

.. code-block:: bash

    $ vagrant up openstack_config
    $ vagrant ssh openstack_config

Now bootstrap the salt master service on the config node, get the salt master bootstrap script, configure it with parameters.

.. code-block:: bash

    $ wget bootstrap-salt-master-pkg.sh

    $ export RECLASS_ADDRESS=https://github.com/tcpcloud/workshop-salt-model.git
    $ export CONFIG_HOST=config.openstack.local

    $ sh bootstrap-salt-master.sh

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
.. _Vagrant downloads page: https://www.vagrantup.com/downloads.html
