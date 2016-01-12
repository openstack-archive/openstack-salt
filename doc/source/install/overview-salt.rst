
SaltStack configuration
=======================

OpenStack-Salt Deployment uses Salt configuration platform to install and manage OpenStack. Salt is an automation platform that greatly simplifies system and application deployment. Salt infrastructure uses asynchronous and reliable RAET protocol to communicate and it provides speed of task execution and message transport. 

Salt uses *formulas* to define resources written in the YAML language that orchestrate the individual parts of system into the working entity. For more information, see `Salt - Intro to Playbooks <http://docs.Salt.com/playbooks_intro.html>`_.

This guide refers to the host running Salt formulas and metadata service as the *master* and the hosts on which Salt installs OSA as the *minions*.

A recommended minimal layout for deployments involves five target hosts in total: three infrastructure hosts, and two compute host. All hosts require one network interface. More information on setting up target hosts can be found in `the section called "Server topology" <overview-server-topology.html>`_.

For more information on physical, logical, and virtual network interfaces within hosts see `the section called "Host
networking" <overview-hostnetworking.html>`_.

--------------

.. include:: navigation.txt
