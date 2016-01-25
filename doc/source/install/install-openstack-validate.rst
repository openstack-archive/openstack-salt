
Validate OpenStack services
================================

Everything should be up and running now. You should execute a few checks
before continue. Execute following checks on one or all control nodes.

Check GlusterFS status:

    .. code-block:: bash

       gluster peer status
       gluster volume status

Check Galera status (execute on one of the controllers):

    .. code-block:: bash

       mysql -p<PWD> -e'SHOW STATUS;'

Check OpenContrail status:

    .. code-block:: bash

       contrail-status

Check OpenStack services:

    .. code-block:: bash

       nova-manage service list
       cinder-manage service list

Source keystone credentials and try Nova API:

    .. code-block:: bash

       source keystonerc
       nova list

--------------

.. include:: navigation.txt
