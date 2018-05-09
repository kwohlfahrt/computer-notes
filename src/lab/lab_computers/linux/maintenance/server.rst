Server Administration
=====================

This section details some common maintenance tasks to be undertaken on the
server.

We use the following common definitions:

``root``
  The root user.
``server``
  The hostname of the server.

Filesystem Maintenance
++++++++++++++++++++++

This section provides a quick overview of common tasks that should be performed
on BTRFS filesystems. Refer to the :ref:`BTRFS Guide <btrfs-guide>` for details.

The filesystem should be `scrubbed` once per month. If a particular file is
being read or written often, it may improve performance to `defragment` it. The
`drive stats` should be monitored weekly, to provide warning of disk failure.

The guide contains instructions for adding or replacing a drive.

Disk Maintenance
----------------

The SMART-Tools package provides a utility to check the health of a drive::

  root@server> smartctl -H /dev/<drive>

The SMART daemon is currently configured to mail ``root`` if it detects
potential issues, so check that mail frequently.

Partitioning a Drive
--------------------

When replacing or adding a new drive, the largest (i.e. data) partition should
be first. Partitions can be easily shrunk from the end, but not the beginning.
Currently, the following layout is suggested:

1. Data partition
   - Type: ``8300 (Linux filesystem)``
   - Size: Remaining space
2. EFI System partition
   - Type: ``ef00 (EFI System)``
   - Size: 512 MiB

The ``cgdisk`` tool is recommended for interactive partitioning, and the
``sgdisk`` tool for scripting.

Kerberos Maintenance
++++++++++++++++++++

If for some reason the current master key encryption type is obsoleted, it
should be updated. This requires the ``kdb5_util`` and ``ktutil`` tools. Use the
following definitions:

``<enctype>``
  The new encryption type, e.g. ``aes256-sha2``.
``<stashfile>``
  The key stash file location, e.g. ``/etc/krb5kdc/stash``.
``<kvno>``
  The key version number determined below, e.g. ``2``.

First, add the new master key::

  root@server> kdb5_util -r REALM.EXAMPLE.COM add_mkey -e <enctype>
  Creating new master key for master key principal 'K/M@REALM.EXAMPLE.COM'
  You will be prompted for a new database Master Password.
  It is important that you NOT FORGET this password.
  Enter KDC database master key:
  Re-enter KDC database master key to verify:

Then, check what the current `kvno` (key version number) is::

  root@server> kadmin getprinc K/M@REALM.EXAMPLE.COM
  Principal: K/M@REALM.EXAMPLE.COM
  Expiration date: [never]
  Last password change: [never]
  Password expiration date: [never]
  Maximum ticket life: 7 days 00:00:00
  Maximum renewable life: 7 days 00:00:00
  Last modified: Mon Jan 01 00:00:00 UTC 2000 (K/M@REALM.EXAMPLE.COM)
  Last successful authentication: [never]
  Last failed authentication: [never]
  Failed password attempts: 0
  Number of keys: 2
  Key: vno 2, aes256-cts-hmac-sha384-192
  Key: vno 1, aes256-cts-hmac-sha1-96
  MKey: vno 2
  Attributes: DISALLOW_ALL_TIX REQUIRES_PRE_AUTH
  Policy: [none]

In this case, we want the highest ``Key: vno`` value. The encryption type
following should match the ``<enctype>`` provided to the previous command.

Then, add the new key to the stash all replicas::

  root@server> ktutil
  ktutil: add_entry -password -p K/M@REALM.EXAMPLE.COM -k <kvno> -e <enctype>
  ktutil: write_kt <stashfile>

Finally, set the new master key as active, re-encrypt all principals and delete
the old master key::

  root@server> kdb5_util -r REALM.EXAMPLE.COM use_mkey 2
  root@server> kdb5_util -r REALM.EXAMPLE.COM update_princ_encryption
  Re-encrypt all keys not using master key vno 2?
  (type 'yes' to confirm)? yes
  29 principals processed: 29 updated, 0 already current
  root@server> kdb5_util purge_mkeys
  Will purge all unused master keys stored in the 'K/M@REALM.EXAMPLE.COM' principal, are you sure?
  (type 'yes' to confirm)? yes
  OK, purging unused master keys from 'K/M@REALM.EXAMPLE.COM'...
  Purging the following master key(s) from K/M@REALM.EXAMPLE.COM:
  KVNO: 1
  1 key(s) purged.
