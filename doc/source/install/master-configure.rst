
Configuring the operating system
================================

The configuration files will be installed to :file:`/etc/salt` and are named
after the respective components, :file:`/etc/salt/master`, and
:file:`/etc/salt/minion`.

By default the Salt master listens on ports 4505 and 4506 on all
interfaces (0.0.0.0). To bind Salt to a specific IP, redefine the
"interface" directive in the master configuration file, typically
``/etc/salt/master``, as follows:

.. code-block:: diff

   - #interface: 0.0.0.0
   + interface: 10.0.0.1

After updating the configuration file, restart the Salt master.
for more details about other configurable options.
Make sure that mentioned ports are open by your network firewall.

Open salt master config

.. code-block:: bash

    vim /etc/salt/master.d/master.conf

And set the content to the following, enabling dev environment and reclass metadata source.

.. code-block:: yaml

    file_roots:
      base:
      - /srv/salt/env/dev
      - /srv/salt/env/base

    pillar_opts: False

    reclass: &reclass
      storage_type: yaml_fs
      inventory_base_uri: /srv/salt/reclass

    ext_pillar:
      - reclass: *reclass

    master_tops:
      reclass: *reclass

And set the content to the following to setup reclass as salt-master metadata source.

.. code-block:: bash

    vim /etc/reclass/reclass-config.yml


.. code-block:: yaml

    storage_type: yaml_fs
    pretty_print: True
    output: yaml
    inventory_base_uri: /srv/salt/reclass

Configure the master service

.. code-block:: bash

  	# Ubuntu
  	service salt-master restart
  	# Redhat
  	systemctl enable salt-master.service
  	systemctl start salt-master


See the `master configuration reference <https://docs.saltstack.com/en/latest/ref/configuration/master.html>`_
for more details about other configurable options.

--------------

.. include:: navigation.txt
