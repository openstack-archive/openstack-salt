
Metadata validation
===================

Pillars are tree-like structures of data defined on the Salt Master and passed through to minions. They allow confidential, targeted data to be securely sent only to the relevant minion. Pillar is therefore one of the most important systems when using Salt.


Testing scenarios
-----------------

Our testing plan is to test each state with the example pillar:

#. Run ``state.show_sls`` to ensure that it parses properly and have some debugging output,
#. Run ``state.sls`` to run the state we’re on,
#. Run ``state.sls again, capturing output, asserting that ``^Not Run:`` is not present in the output, because if it is then it means that a state cannot detect by itself whether it has to be run or not and thus is not idempotent.


--------------

.. include:: navigation.txt
