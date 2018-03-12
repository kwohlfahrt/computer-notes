Maintenance
===========

This document describes the maintenance of Linux-based lab computers. It is
automated through :ref:`ansible-guide`.

The ansible playbook is executed with the command::

  ansible-playbook --vault-id shared@prompt --vault-id personal@prompt site.yml

Pass the `--check` or `-C` flag to not execute any changes, simply connect and
test which commands will result in changes. Additional information can be found
in the Ansible page of this document.

Vaults
------

There are two vaults that must be set-up:

shared
  Contains secrets (such as default passwords) that are used for the setup of
  the computers.

personal
  Contains secrets specific to the user running the playbook:

  ``vault_kerberos_admin``
    The Kerberos administrator user (if it is not from ``$USER/admin``)

  ``vault_kerberos_passwd``
    The password for the Kerberos admin principal given above.

.. toctree::
   :maxdepth: 2
   :caption: Contents
   :glob:

   *
