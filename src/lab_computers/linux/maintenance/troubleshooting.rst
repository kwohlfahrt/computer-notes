Troubleshooting
===============

This section contains advice on how to solve common problems.

The following users exist:

local
  Literally ``local``, a user which exists on every machine
user
  A normal user
root
  The root user, or run a command with ``sudo``

The following computers exist:

delphi
  The machine called ``delphi``, which hosts most shared services
client
  Any lab computer which is not ``delphi``

Login
+++++

If users cannot login on any computer, this suggests an issue with Kerberos or
LDAP. To fix this problem, you can log in using the username ``local``, which
exists on every computer.

Server
------

There are two server-side services that are necessary for shared logins to work.

Kerberos
~~~~~~~~

To test if Kerberos is available, run ``kinit``. If the key distribution server
is not running, the following error message should be shown::

  > local@client kinit
  kinit: Cannot contact any KDC for realm 'EDL1.BIOC.CAM.AC.UK' while getting initial credentials

The service ``krb5-kdc`` must be restarted::

  > root@delphi systemctl restart krb5-kdc

LDAP
~~~~

To test if the LDAP server is running, run ``ldapsearch`` on a client computer.
If LDAP is not running, the following error message should be shown::

  > local@client ldapsearch
  ldap_sasl_interactive_bind_s: Can't contact LDAP server (-1)

The service ``slapd`` should be restarted::

  > root@delphi systemctl restart slapd
