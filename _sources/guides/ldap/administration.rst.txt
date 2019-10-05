Migration
=========

The output of an ``ldapsearch`` command is suitable for use as input to
``ldapmodify -a``. However, adding an entry (e.g. the group ``users``) that
already exists is an error. Therefore, the entry should be changed to a
modification::

  dn: cn=users,ou=groups,dc=example,dc=com
  objectClass: top
  objectClass: posixGroup
  gidNumber: 100
  cn: users
  memberUid: foo
  memberUid: bar

Should be modified to::

  dn: cn=users,ou=groups,dc=example,dc=com
  changetype: modify
  add: memberUid
  memberUid: foo
  memberUid: bar

Initial Configuration
=====================

The ``ldapmodify`` and ``ldapsearch`` commands only work if there is an
existing, running LDAP server. The two offline equivalents (for ``slapd`` are
``slapadd`` and ``slapcat`` respectively). They also take LDIF formatted
entries.
