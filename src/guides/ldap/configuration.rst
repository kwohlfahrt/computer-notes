Configuration
=============

Configuration is done by applying LDIF formatted changes to the on-line
configuration (OLC), a database with the suffix ``cn=config``. Details can be
found at the `Administrator's Guide`_ and the manual page
:manpage:`slapd-config(5)`.

Configurations can be to global configuration options ``cn=config``, the
configuration database ``olcDatabase={0}config,cn=config``, or any following
database instances (e.g. ``olcDatabase={1}mdb,cn=config`` refers to the first
database, which is an instance of the MDB backend)

.. _Administrator's Guide: https://www.openldap.org/doc/admin/

Authentication
--------------

OpenLDAP primarily uses `SASL` for authentication. To list the available
authentication methods, use::

  ldapsearch -x -H ldapi:/// -b "" -s base supportedSASLMechanisms

Each connection is given an associated `DN`, which can be seen with the
``ldapwhoami`` command. Note this may differ based on the connection type
(``-H``) and authentication mechanism (``-Y``).

It is recommended to remap the authentication DN to an actual users DN. This is
done via the ``olcAuthzRegexp`` attribute of ``cn=config``. It takes a space
separated list of (capturing) regular expression and substitution pattern (with
captured group `N` available as ``$N``). For example::

  {0}uid=([^,]+),cn=gssapi,cn=auth uid=$1,ou=people,dc=example,dc=com

can be used to remap a `GSSAPI`_ authentication to a normal user.

External
~~~~~~~~

The ``EXTERNAL`` authentication method uses information from the connection. For
example, when used with the ``ldapi:///`` transport, the `DN` will be along the
lines of::

  gidNumber=1002+uidNumber=1002,cn=peercred,cn=external,cn=auth

GSSAPI
~~~~~~

GSSAPI is the primary method of authenticating via Kerberos. The `DN` will be
along the lines of::

  uid=user@example.com,cn=gssapi,cn=auth

Note the realm (``@example.com`` is omitted if it is equal do the kerberos
default realm.

Authorization
-------------

Fine-grained permissions are defined with ``olcAccess`` attributes on
``olcDatabase`` entries. They take the following format::

  {n}to <what> by <who> <access> <control>

The ``{n}`` is used to order the control directives. The ``<what>`` portion is a
pattern that controls what the rule applies to. The ``<who>`` pattern matches
against the user and ``<access>`` describes the permissions.

``<control>`` describes how to proceed after processing this rule (after
matching on ``<what>`` and ``<who>``). The default (``stop``) halts processing,
meaning if no further access clauses will be visited. ``continue`` means that
other ``<who>`` patterns in the current clause will be processed, and ``break``
means that other access clauses will be visited.

For more information, see ``man slapd.access``.

Root Access
~~~~~~~~~~~

Each database has a root user. This is the ``olcRootDN`` attribute of the
``olcDatabase`` entry. It may be convenient to set it to match the root user
with the `EXTERNAL <External_>`_ SASL mechanism::

  gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth

Then, the ``olcRootPW`` password can be deleted. Some distributions create a
default user (e.g. ``cn=admin``), which can also be deleted.
