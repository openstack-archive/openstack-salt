
Pillars classification
=========================

Pillar is an interface for Salt designed to offer global values that can be distributed to all minions. Pillar data is managed in a similar way as the Salt State Tree.

Pillar metadata
---------------

TODO

Reclass database
----------------

reclass is an “external node classifier” (ENC) has ability to merge data sources recursively.

Install reclass
~~~~~~~~~~~~~~~~~~

First we will install the application and then configure it.

.. code-block:: bash
    
    cd /tmp
    git clone https://github.com/madduck/reclass.git
    cd reclass
    python setup.py install
    mkdir /etc/reclass
    vim /etc/reclass/reclass-config.yml

And set the content to the following to setup reclass as salt-master metadata source.

.. code-block:: yaml

    storage_type: yaml_fs
    pretty_print: True
    output: yaml
    inventory_base_uri: /srv/salt/reclass

To test reclass you can use CLI to get the complete service catalog or 

Connect salt-minion to master
-----------------------------

Restart the minion

.. code-block:: bash

    service salt-minion restart
   
Accept salt-minion key on master

.. code-block:: bash

    salt-key -A


--------------

.. include:: navigation.txt
