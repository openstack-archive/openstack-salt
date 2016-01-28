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


Environment setup 
-----------------

The environment consists of 3 nodes:

* config: Salt master node, IP: 10.10.10.200
* control: OpenStack control node, IP: 10.10.10.201
* compute: OpenStack compute node, IP: 10.10.10.202

Minion configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~

Prepare basic configuration files for each node deployed.

Set ``/srv/vagrant-openstack/minion/config.conf`` to following:

.. literalinclude:: ../../../scripts/vagrant-openstack/config.conf
   :language: yaml
   :linenos:

Set ``/srv/vagrant-openstack/minion/control.conf`` to following:

.. literalinclude:: ../../../scripts/vagrant-openstack/control.conf
   :language: yaml
   :linenos:

Set ``/srv/vagrant-openstack/minion/compute.conf`` to following content:

.. literalinclude:: ../../../scripts/vagrant-openstack/compute.conf
   :language: yaml
   :linenos:

Vagrant configuration file
~~~~~~~~~~~~~~~~~~~~~~~~~~

This configuration is positioned at ``/srv/vagrant-openstack/Vagrantfile``.

.. literalinclude:: ../../../scripts/vagrant-openstack/Vagrantfile
   :language: ruby
   :linenos:

Launching the Vagrant nodes
---------------------------

First we setup openstack config node. Launch the node using vagrant command:

.. code-block:: bash

    $ cd /srv/vagrant-openstack
    $ vagrant up openstack_config
    $ vagrant ssh openstack_config

.. code-block:: bash

    $ cd /srv/vagrant-openstack
    $ vagrant show

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
.. _Vagrant downloads page: https://www.vagrantup.com/downloads.html
