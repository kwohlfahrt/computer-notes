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
