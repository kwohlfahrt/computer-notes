.. _btrfs-guide:

BTRFS
=====

This subsection describes some tasks which may be useful for administering BTRFS
file-systems.

We use the following common definitions:

``<mnt>``
  The mount point of the file-system (e.g. ``/`` or ``/mnt``)
``<device>``
  A device containing a BTRFS file-system (e.g. ``/dev/sda``)
``<partition>``
  A partition containing a BTRFS file-system (e.g. ``/dev/sda1``)

Scrubbing
+++++++++

BTRFS file-systems can be checked (and have errors corrected) on-line::

  root@server> btrfs scrub start <mnt>

Use the ``-c 3`` flag to set the I/O class to `idle`, so normal disk operations
are not affected (see ``man ionice``). The status of a running scrub can be
queried::

  root@server> btrfs scrub status <mnt>
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

Drive Stats
+++++++++++

This section discusses how to monitor drives for hardware errors. BTRFS tracks
the number of errors produced by drives in an array::

  root@server> btrfs device stats --check <mnt>
  [/dev/sda1].write_io_errs    0
  [/dev/sda1].read_io_errs     0
  [/dev/sda1].flush_io_errs    0
  [/dev/sda1].corruption_errs  0
  [/dev/sda1].generation_errs  0

Note these are cumulative over the lifetime of the partition. To reset the
statistics, pass the ``--reset`` argument. This will print the current counts,
and then reset the counters to zero. This command can also be run on a
``<partition>``, if it is mounted.

Disk Management
+++++++++++++++

This section details adding or removing physical disks from the underlying
filesystem. We have the following definitions:

``<new-device>``
  The path to the new replacement device (e.g. ``/dev/sdb``)
``<new-partition>``
  The path to the main partition on the replacement device (e.g. ``/dev/sdb1``)

Unless otherwise indicated, commands to manage disks can be run while the
filesystem is in use.

Adding
------

To add a new disk to an array, simply run::

  root@server> btrfs device add <new-partition> <mnt>

.. Note:: It may be necessary to `rebalance <Rebalancing_>`_ after adding a new
   device.

Removing
--------

To remove a disk from an array, run::

  root@server> btrfs device remove <partition> <mnt>

Replacing
---------

Working Disk
~~~~~~~~~~~~

To replace a drive, use the ``btrfs replace`` command::

  root@server> btrfs replace start <partition> <new-partition> <mnt>
  root@server> btrfs replace status <mnt>
  Started on 27.Mar 22:34:20, finished on 28.Mar 06:36:15, 0 write errs, 0 uncorr. read errs

The second command will exit when the replace has finished. If ``<partition>``
is slow to read from (e.g. due to a partial failure), pass the ``-r`` flag to
the ``btrfs replace start`` command to prefer other mirrors.

.. Note:: If the replacement drive is larger than the original drive, the
   file-system should be `resized <Resizing_>`_ to make use of all available
   space.

Failed Disk
~~~~~~~~~~~

If a filesystem is unmounted (e.g. due to the machine being turned off) when a
disk is removed or fails, you will need to boot from a LiveCD and mount the disk
array as degraded::

  root@server> mount -o degraded <partition> /mnt

Find out which disk is missing::

  root@server> btrfs file-system show <mnt>
  Label: none  uuid: d934d8bd-b027-43b1-9ec9-8a10b15a3bef
    Total devices 6 FS bytes used 11.72TiB
    devid    1 size 7.28TiB used 1.86TiB path /dev/sda1
    devid    3 size 7.28TiB used 7.16TiB path /dev/sdf3
    devid    4 size 3.64TiB used 3.64TiB path /dev/sdb2
    devid    5 size 3.64TiB used 3.64TiB path /dev/sdd2
    devid    6 size 5.46TiB used 5.34TiB path /dev/sde2

In this case, ``devid 2`` is missing. For the ``btrfs replace`` command, we
should pass the device number (``2``) instead of the path to the old partition.
Otherwise, proceed as described for a `Working Disk`_.

Resizing
--------

To resize a BTRFS file-system to its maximum possible size, use the following
command::

  root@server> btrfs file-system resize max <mnt>

.. Note:: It may be necessary to `rebalance <Rebalancing_>`_ after resizing the
   file-system.

.. Note:: It may be necessary to adjust `quotas <Quotas_>`_ after resizing the
   file-system.

Rebalancing
-----------

If ``btrfs file-system show`` shows that all free space is concentrated on one
drive, it is necessary to rebalance the file-system::

  root@server> btrfs balance start --background --full-balance <mnt>

To view the status of a running balance use::

  root@server> btrfs balance status <mnt>

A balance can be run while the disk is online, but it may degrade performance.
As such, it should be run during periods of low usage (e.g. weekends). A running
balance can be paused/resumed with the commands ``btrfs balance pause <mnt>``
and ``btrfs balance resume <mnt>``.

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

The commands ``btrfs qgroup show`` (for used space) and ``btrfs filesystem
usage`` (for free space) are useful to determine the desired quota limit. They
both take ``--iec`` and unit (e.g. ``--gbytes``) options.

.. WARNING:: Quotas have known issues when combined with many snapshots, making
   some operations (e.g. balancing) unusably slow.

Recovery
++++++++

This section details possible responses to file-system corruption.

If a file-system can be mounted, a `scrub <Scrubbing_>`_ should be run. If a
file-system cannot be mounted, read-only and recovery options might help::

  root@livecd> mount -o ro,norecovery,usebackuproot <device> <mountpoint>

This uses backup metadata to mount the file-system. If this fails, an offline
check can be run::

  root@livecd> btrfs check <device>

At this point, it is advised to contact the developers (e.g. over IRC) to
interpret the errors.

.. Attention:: Older versions of btrfs-check often report false-positive errors.

Subvolumes
++++++++++

A BTRFS system is split into multiple subvolumes, which can be managed
independently.

Read-only
---------

A subvolume can be marked read-only by setting the ``ro`` property to ``true``::

  root@server> btrfs property set <mnt> ro true

To set allow writing, set it to ``false``.
