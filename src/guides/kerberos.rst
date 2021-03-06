.. _kerberos-guide:

Kerberos
========

Kerberos_ is an authentication system that is integrated with many programs. A
central server stores user and password combinations, and grants "tickets" to
authenticated users or services.

This document is an overview of some basic Kerberos principles. Detailed
instructions can be found in the :ref:`user-management` document.

.. _Kerberos: https://web.mit.edu/kerberos/

Tickets
-------

When a user authenticates with the Kerberos server, they receive a "ticket
granting ticket". Then, they can use this ticket to authenticate to other
services which are also Kerberos enabled (e.g. SSH or NFS) without re-entering
their password.

The three commands used to manage tickets are ``kinit``, ``klist`` and
``kdestroy`` to request, list and delete tickets respectively.

Principals
----------

Principals (similar to a user, but also refers to e.g. authenticated computers
or services) are of the form ``name@REALM``, where the realm is a unique domain,
traditionally uppercase. For the lab, I have chosen `EDL1.BIOC.CAM.AC.UK`.

Administration
~~~~~~~~~~~~~~

Administration is done via the ``kadmin`` tool. This can be used from client
machines if you have an adminstrator principal (see `Names`_), or from the
Kerberos server directly with ``kadmin.local`` (requires root access).

``?`` prints available commands, and details can be found in the ``kadmin``
`manual pages <kadmin_>`_.

The commonly used commands are ``list_principals``, ``add_principal``,
``delete_principal``, ``modify_principal``, and ``change_password``.

.. _kadmin: https://web.mit.edu/kerberos/krb5-latest/doc/admin/admin_commands/kadmin_local.html

Names
~~~~~

The format of the name part depends on the type of principal.

user
  Users are asigned an individual name, ideally their CRSID (e.g. ``js123``).
  Administrators of the Kerberos database have two names, their normal name and
  one matching a rule in the `acl_file`_.
machine
  Computers are assigned a name of the format ``host/hostname`` (e.g.
  ``host/foo.example.com``)
services
  Services are assigned a name of the format ``service/hostname`` (e.g.
  ``ldap/foo.example.com``)


The following special principals exist and are used by Kerberos internally:
``K/M``, ``kadmin/history``, ``kadmin/changepw``, and ``krbtgt/REALM``.

Roles
~~~~~

A principal is assigned to a role, which specifies the password requirements,
number of allowed failed attempts, etc. 

Configuration
-------------

Server
~~~~~~

``/etc/krb5kdc/kdc.conf``
  The primary configuration file. It sets the locations of the files described
  below.

``key_stash_file``
  A stored copy of the master key. Necessary to allow the server to begin
  functioning on boot, without manually entering a key.

.. _acl_file:

``acl_file``
  Administration ACL. Describes which modifications are allowed for each
  principal.

Client
~~~~~~

``/etc/krb5.conf``
  The main configuration file. Sets the location of servers for multiple realms,
  and default options for tickets.
