
Pillars classification
=========================

Pillar is an interface for Salt designed to offer global values that can be distributed to all minions. Pillar data is managed in a similar way as the Salt State Tree.

Setup reclass database
----------------------

reclass is an “external node classifier” (ENC) has ability to merge data sources recursively. First we will install the application and then configure it.

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

Using SaltStack
===========================

Remote execution principles carry over all aspects of Salt platform. Command are made of:

- **Target** - Matching minion ID with globbing,  regular expressions, Grains matching, Node groups, compound matching is possible
- **Function** - Commands haveform: module.function, arguments are YAML formatted, compound commands are possible

Try test run to reach minion

.. code-block:: bash

    salt '*' test.version

Targetting minions
------------------

Examples of different kinds of targetting minions

.. code-block:: bash

    salt -E '.*' apache.signal restart
    salt -G 'os:Fedora' test.version
    salt '*' cmd.exec_code python 'import sys; print sys.version'

First SaltStack commands
------------------------

Minion facts

.. code-block:: bash

    salt-call grains.items

Minion parameters

.. code-block:: bash

    salt-call pillar.data

Sync state

.. code-block:: bash

    salt-call state.highstate

Metadata SaltStack command
------------------------


Pillar of Salt

    Global values that can be distributed to all minions
    Good for sensitive data
    Possible external pillars:
      Reclass
      Hiera

--------------

.. include:: navigation.txt
