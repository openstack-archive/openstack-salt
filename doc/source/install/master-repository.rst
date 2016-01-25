
Setting up package repository
================================

Use ``curl`` to install your distribution's stable packages. Examine the downloaded file ``install_salt.sh`` to ensure that it contains what you expect (bash script). You need to perform this step even for salt-master instalation as it adds official saltstack package management PPA repository.

.. code:: console

  apt-get install vim curl git-core
  curl -L https://bootstrap.saltstack.com -o install_salt.sh
  sudo sh install_salt.sh

Install the Salt master from the apt repository with the apt-get command after you installed salt-minion.

.. code-block:: bash

  sudo apt-get install salt-minion salt-master reclass

.. Note::

Instalation is tested on Ubuntu Linux 12.04/14.04, but should work on any distribution with python 2.7 installed.
You should keep Salt components at current stable version.

--------------

.. include:: navigation.txt
