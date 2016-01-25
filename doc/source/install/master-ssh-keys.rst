
Configuring Secure Shell (SSH) keys
===================================

Generate SSH key file for accessing your reclass metadata and development formulas.

.. code-block:: bash

    mkdir /root/.ssh
    ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -q -N ""
    chmod 400 /root/.ssh/id_rsa

Create SaltStack environment file root, we will use ``dev`` environment.

.. code-block:: bash

    mkdir /srv/salt/env/dev -p

Get the reclass metadata definition from the git server.

.. code-block:: bash

    git clone git@github.com:tcpcloud/workshop-salt-model.git /srv/salt/reclass

Get the core formulas from git repository server needed to setup the rest.

.. code-block:: bash

    git clone git@github.com:tcpcloud/salt-formula-linux.git /srv/salt/env/dev/linux -b develop
    git clone git@github.com:tcpcloud/salt-formula-salt.git /srv/salt/env/dev/salt -b develop
    git clone git@github.com:tcpcloud/salt-formula-openssh.git /srv/salt/env/dev/openssh -b develop
    git clone git@github.com:tcpcloud/salt-formula-git.git /srv/salt/env/dev/git -b develop

--------------

.. include:: navigation.txt
