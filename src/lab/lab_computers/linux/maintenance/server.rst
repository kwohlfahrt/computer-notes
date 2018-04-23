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
  The mount point of the file-system (e.g. ``/`` or ``/mnt``)

Scrubbing
+++++++++

BTRFS file-systems can be checked (and have errors corrected) on-line. This
should be run approximately once per month::

  root@server> btrfs scrub start /

Use the ``-c 3`` flag to set the I/O class to `idle`, so normal disk operations
are not affected (see ``man ionice``). The status of a running scrub can be
queried::

  root@server> btrfs scrub status /
  scrub status for d934d8bd-b027-43b1-9ec9-8a10b15a3bef
        scrub started at Fri Mar 23 11:06:46 2018, running for 00:00:25
        total bytes scrubbed: 22.42GiB with 0 errors

Defragmenting
+++++++++++++

BTRFS supports defragmentation to improve performance::

  root@server> btrfs filesystem defragment <file>

To recursively defragment a directory (this does not traverse subvolumes), pass
the ``-r`` option.

.. WARNING:: Defragmenting files removes data sharing with the snapshot being
   defragmented, and will considerably increase disk usage.

Drive Testing
+++++++++++++

This section discusses how to monitor drives for hardware errors. We have the
following definitions:

``<drive>``
  The path to the drive being checked (e.g. ``/dev/sda``)

BTRFS
-----

BTRFS tracks the number of errors produced by drives in an array::

  root@server> btrfs device stats --check /
  [/dev/sda1].write_io_errs    0
  [/dev/sda1].read_io_errs     0
  [/dev/sda1].flush_io_errs    0
  [/dev/sda1].corruption_errs  0
  [/dev/sda1].generation_errs  0

Note these are cumulative over the lifetime of the partition. To reset the
statistics, pass the ``--reset`` argument. This will print the current counts,
and then reset the counters to zero.

SMART-Tools
-----------

The SMART-Tools package provides a utility to check the health of a drive::

  root@server> smartctl -H /dev/<drive>

Replacing a Drive
+++++++++++++++++

In this section, we have the following definitions:

``<newdev>``
  The path to the new replacement drive (e.g. ``/dev/sdb``)
``<fsdev>``
  The path to any device in the root file-system (e.g. ``/dev/sda``)

To replace a drive, first remove the old drive and insert the new one. If this
requires turning off the machine, you will need to boot from a LiveCD and mount
the disk array as degraded::

  root@server> mount -o degraded <fsdev> /mnt

Then, partition the new disk::

  root@server> cgdisk <newdev>

Find out which disk is missing::

  root@server> btrfs file-system show <mnt>
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
   file-system should be `resized <Resizing_>`_ to make use of all available
   space.

Resizing
--------

To resize a BTRFS file-system to its maximum possible size, use the following
command::

  root@server> btrfs file-system resize max <mnt>

This can be run while the file-system is in use.

.. Note:: It may be necessary to `rebalance <Rebalancing_>`_ after resizing the
   file-system.

.. Note:: It may be necessary to adjust `quotas <Quotas_>`_ after resizing the
   file-system.

Rebalancing
-----------

If ``btrfs file-system show`` shows that all free space is concentrated on one
drive, it is necessary to rebalance the file-system::

  root@server> btrfs balance start --background --full-balance <mnt>

This can be run while the file-system is in use.

To view the status of a running balance use::

  root@server> btrfs balance status <mnt>

Quotas
++++++

BTRFS uses quotas to manage space between subvolumes on a single file-system.
Each subvolume automatically belongs to a bottom-level quota group (or `qgroup`)
(``0/<subvolume-id>``). These qgroups can then be hierarchically assigned to
higher-level groups; i.e. each qgroup at level ``0/``, can be a member of one or
more qgroups at level ``1/``, and each qgroup at level ``1/`` can be a member of
qgroups of level ``2/`` and so on.

To show quota groups, parents and limits, use ``btrfs qgroup show -rep <path>``::

  root@server> btrfs qgroup show -rep /
  qgroupid         rfer         excl     max_rfer     max_excl parent
  --------         ----         ----     --------     -------- ------
  0/258         4.23GiB      4.23GiB         none         none ---
  0/259        10.04TiB      1.53MiB         none         none 1/100
  0/657         3.30TiB      2.83TiB         none         none 1/100
  0/60173      10.04TiB      1.12MiB         none         none 1/100
  1/100        14.38TiB     14.38TiB     14.45TiB         none ---

The ``rfer`` column gives information about how much data the qgroup contains,
and the ``excl`` column shows how much data is exclusive to that qgroup (i.e.
not shared by a snapshot). The ``max_`` columns list the respective limits, and
``parent`` shows any parents of this qgroup.

To set a limit for a qgroup, use ``btrfs qgroup limit <size> <qgroup> <path>``::

  root@server> btrfs qgroup limit 10T 1/100 /

The ``<path>`` is the path where the file-system is mounted. ``<size>`` can have
suffixes (``K``, ``M``, ``G``, ``T``, referring to ``KiB``, ``MiB``, etc.).

.. Warning:: Quotas should be used only with Linux and btrfs-progs version 4.14
   or higher.

Recovery
++++++++

This section details possible responses to file-system corruption.

If a file-system can be mounted, a `scrub <Scrubbing_>`_ should be run. If a
file-system cannot be mounted, read-only and recovery options might help::

  root@livecd> mount -o ro,recovery <device> <mountpoint>

This uses backup metadata to mount the file-system. If this fails, an offline
check can be run::

  root@livecd> btrfs check <device>

At this point, it is advised to contact the developers (e.g. over IRC) to
interpret the errors.

.. Attention:: Older versions of btrfs-check often report false-positive errors.
