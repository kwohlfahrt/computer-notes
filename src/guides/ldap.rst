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
----

LDAP databases are managed by inputs in LDIF (LDAP Data Interchange Format).
These can be saved files for initial set-up, or dynamic inputs to change user
data.

Additions
~~~~~~~~~

Additions are performed with the ``ldapmodify -a`` command, and entries in LDIF
format (via stdin or at the prompt)::

  dn: uid=js123,ou=people,dc=example,dc=com
  objectClass: posixAccount
  uid: js123
  uidNumber: 1001
  gidplantNumber: 1001
  homeDirectory: /home/js123
   
  dn: uid=jd321,ou=people,dc=example,dc=com
  objectClass: posixAccount
  uid: jd321
  uidNumber: 1002
  gidNumber: 1002
  homeDirectory: /home/jd321

Modifications
~~~~~~~~~~~~~

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

Configuration
-------------

Configuration is done by applying LDIF formatted changes to the on-line
configuration (OLC), a database with the suffix ``cn=config``. Details can be
found at the `Administrator's Guide`_ and the manual page
:manpage:`slapd-config(5)`.

Configurations can be to global configuration options ``cn=config``, the
configuration database ``olcDatabase={0}config,cn=config``, or any following
database instances (e.g. ``olcDatabase={1}hdb,cn=config`` refers to the first
database, which is an instance of the HDB backend)

.. todo:: Describe setup of lab LDAP server

.. _Administrator's Guide: https://www.openldap.org/doc/admin/
