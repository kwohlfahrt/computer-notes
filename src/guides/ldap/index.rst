.. _ldap-guide:

LDAP
====

LDAP_ (Lightweight Directory Access Protocol) is a protocol to share directory
information (e.g. names, e-mail addresses, etc). The OpenLDAP_ project maintains
an open-source LDAP server and client.

.. _LDAP: https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol
.. _OpenLDAP: https://www.openldap.org/

Entries
-------

Each record is identified by a unique distinguished name (DN). These are
hierarchical identifies, consisting of multiple domain components (dc) and other
descriptors. For example, the ``sudo`` group at the domain ``example.com`` would
have the DN ``cn=sudo,ou=groups,dc=example,dc=com``.

Each entry must have an associated ``objectClass``, which defines what
attributes an entry must define. For example, a ``objectClass: posixGroup``
entry must define a ``gidNumber`` and a name (``cn``).

LDIF
~~~~

The command-line tools input and output LDIF (LDAP Data Interchange Format).
This is a human-readable text format that describes LDAP entries.

Queries
-------

The LDAP server can be manually searched with the ``ldapsearch`` command. For
example, to search for the user ``foo``, use ``ldapsearch uid=foo``. This will
show all attributes of the entry, but not any of its children (see `Bases`_
below for that).

Bases
~~~~~

As an LDAP directory is a hierarchical format, can specify a base to restrict
your search to. The default base is set in ``/etc/ldap/ldap.conf``::

  BASE    dc=example,dc=com

To view all children in a particular base, use the ``-b`` flag. To list all
users, this would be ``ldapsearch -b ou=people,dc=example,dc=com`` (the
``dc=...`` part may differ for other domains).


Modifications
-------------

Modifications are performed with the ``ldapmodify`` command, and entries in LDIF
format (via stdin or at the prompt)::

  dn: uid=js123,ou=people,dc=example,dc=com
  changetype: modify
  replace: homeDirectory
  homeDirectory: /new_home/js123

Multiple attributes can be changed in one query, using ``-`` to separate
changes to the same directory::

  dn: cn=users,ou=groups,dc=example,dc=com
  changetype: modify
  add: memberuid
  memberuid: js123
  -
  add: memberuid
  memberuid: jd321

If only one attribute is added, this can be shortened::

  dn: cn=users,ou=groups,dc=example,dc=com
  changetype: modify
  add: memberuid
  memberuid: js123
  memberuid: jd321

Additions
~~~~~~~~~

Additions are performed with ``changetype: add``::

  dn: uid=js123,ou=people,dc=example,dc=com
  changetype: add
  objectClass: posixAccount
  uid: js123
  uidNumber: 1001
  gidplantNumber: 1001
  homeDirectory: /home/js123

Alternatively, the ``changetype: add`` can be omitted ``ldapadd`` or
``ldapmodify -a`` is used.

Administration
--------------

The pages below deal with common tasks in administering LDAP databases.

.. toctree::
   :maxdepth: 1
   :glob:

   *
