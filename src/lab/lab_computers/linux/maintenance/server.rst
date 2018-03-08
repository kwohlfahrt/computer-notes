Server Administration
=====================

This section details some common maintenance tasks to be undertaken on the
server.

We use the following common definitions:

``root``
  The root user.
``server``
  The hostname of the server.
``<mnt>``
  The mount point of the filesystem (e.g. ``/`` or ``/mnt``)

Replacing a Drive
+++++++++++++++++

In this section, we have the following definitions:

``<newdev>``
  The path to the new replacement drive (e.g. ``/dev/sdb``)
``<fsdev>``
  The path to any device in the root filesystem (e.g. ``/dev/sda``)

To replace a drive, first remove the old drive and insert the new one. If this
requires turning off the machine, you will need to boot from a LiveCD and mount
the disk array as degraded::

  root@server> mount -o degraded <fsdev> /mnt

Then, partition the new disk::

  root@server> cgdisk <newdev>

Find out which disk is missing::

  root@server> btrfs filesystem show <mnt>
  Label: none  uuid: d934d8bd-b027-43b1-9ec9-8a10b15a3bef
    Total devices 6 FS bytes used 11.72TiB
    devid    1 size 7.28TiB used 1.86TiB path /dev/sda1
    devid    3 size 7.28TiB used 7.16TiB path /dev/sdf3
    devid    4 size 3.64TiB used 3.64TiB path /dev/sdb2
    devid    5 size 3.64TiB used 3.64TiB path /dev/sdd2
    devid    6 size 5.46TiB used 5.34TiB path /dev/sde2

In this case, ``devid 2`` is missing. So we replace the disk with id ``2`` with 
the new device::

  root@server> btrfs replace start 2 <newdev> <mnt>
  root@server> btrfs replace status <mnt>

The second command will exit when the replace has finished.

.. Note:: If the replacement drive is larger than the original drive, the
   filesystem should be `resized <Resizing_>`_ to make use of all available
   space.

Resizing
--------

To resize a BTRFS filesystem to its maximum possible size, use the following
command::

  root@server> btrfs filesystem resize max <mnt>

This can be run while the filesystem is in use.

.. Note:: It may be necessary to `rebalance <Rebalancing_>`_ after resizing the
   filesystem.

Rebalancing
-----------

If ``btrfs filesystem show`` shows that all free space is concentrated on one
drive, it is necessary to rebalance the filesystem::

  root@server> btrfs balance start --background --full-balance <mnt>

This can be run while the filesystem is in use.

To view the status of a running balance use::

  root@server> btrfs balance status <mnt>
