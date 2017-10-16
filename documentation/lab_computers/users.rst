.. _user-management:

User Management
===============

This document outlines the steps necessary to create a new user.

Kerberos
--------

Open the Kerberos admin console, and use the ``add_principal`` command::

  kadmin
  > add_principal

At which point you will be prompted to choose a password for the new user.
Optionally, an expiry date for the user may be proviced, in the form ``-expire
date``, where ``date`` may be any text undetstood by the ``getdate`` command
(e.g. ``-expire 2010-08-21``). The ``default`` policy is used for users, so it
does not need to be explicitly state.

See the :ref:`kerberos-guide` document for an introduction to Kerberos.

LDAP
----

First search the existing LDAP users to find a free UID/GID::

  ldapsearch -LLL objectClass=posixAccount filter gidNumber

Then, log-in as and admin user::

  kinit username/admin

Then, add the necessary user and group, and add the user to the ``users`` group.
A shell script is provided for convenience to generate the appropriate LDIF::

  ./ldapuser.sh CRSID UID First Middle 'Last Name'

Note the first two arguments are the CRSID and UIDs, and the last argument is
the users last name (so quote it if it contains spaces). The remaining arguments
are first name(s). So, for example::

  ./ldapuser.sh js123 1005 John Smith | ldapadd

If the user should have administrator privileges, he should be added to the
``sudo`` group (use this carefully!)::

  $ ldapmodify
  dn: cn=sudo,ou=groups,dc=edl1,dc=bioc,dc=cam,dc=ac,dc=uk
  changetype: modify
  add: memberuid
  memberuid: ${1}

See the :ref:`ldap-guide` document for an introduction to LDAP.

.. todo::
   The UID/GID should automatically increment, this is not yet implemented. It
   would mean it is no longer necessary to search UIDs and manually choose one.

Home Directory
--------------

Home directories on lab linux computers should be automatically created on first
login via PAM. However, it is necessary to create a home directories on the
storage server (one in ``/home``, and one in ``/home/scratch``).
