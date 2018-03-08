Maintenance
===========

This document describes the maintenance of Linux-based lab computers. It is
automated through :ref:`ansible-guide`.

The ansible playbook is executed with the command::

  ansible-playbook site.yml

Pass the `--check` or `-C` flag to not execute any changes, simply connect and
test which commands will result in changes. Additional information can be found
in the Ansible page of this document.

.. toctree::
   :maxdepth: 2
   :caption: Contents
   :glob:

   *
