Installation
============

This document covers the installation of Debian Linux and set-up of a new
computer.

Requirements
++++++++++++

The system must have a network connection and be running a Linux variant that
contains `bash` and `apt`. The `GRML`_ or `Debian Live`_ USBs are recommended.

You must also install and start an ssh server if it is not included by default::

  root@livecd > apt update
  root@livecd > apt install openssh-server
  root@livecd > systemctl start ssh

Then, you must find the IDs of the disks you plan to use for data and (optional)
cache::

  user@livecd > lsblk
  NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
  sda      8:0    0   1.8T  0 disk 
  sdb      8:16   0 931.5G  0 disk 
  sdc      8:32   0 447.1G  0 disk 

These should be paths that start with ``/dev/disk/by-id`` [#disk-id]_, so we
find these paths [#duplicate-id]_::

  user@livecd > ls -l /dev/disk/by-id
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5d1e -> ../../sda
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5e9c -> ../../sdb
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5e58 -> ../../sdc

Bootstrap
+++++++++

A shell script [#bootstrap]_ is provided to bootstrap the system, this is called
``bootstrap.sh``. All hard disks to be used must be passed as command-line
arguments. The ``--cache`` option must be specified before each disk which is to
be used as a cache. We copy this to the remote machine::

  user@admin > scp bootstrap.sh user@computer:/tmp/

.. Warning:: The following step will wipe all of the specified disks.

And then run it (on the remote machine). Specify your LiveCD username with the
``--user`` option (defaults to ``user``)::

  root@livecd > /tmp/bootstrap.sh --user user --cache /dev/disk/by-id/wwn-0x5e58
  /dev/disk/by-id/wwn-0x5e9c /dev/disk/by-id/wwn-0x5d1e

.. Note:: This script sets up a chroot jail for SSH, so keep one or more
          connections open in case of errors.

This will leave us with a usable system we can `chroot` into in ``/mnt``.

.. Warning:: The system is not yet bootable, so do not restart the computer.

Important Facts
---------------

We also have to find the `UUID` of the root filesystem. This must map to the
same device as ``/dev/mapper/Root-Data``::

  user@livecd > ls -l /dev/mapper
  lrwxrwxrwx 1 root root       7 Jan 11 16:25 Root-Data -> ../dm-0
  user@livecd > ls -l /dev/disk/by-uuid
  lrwxrwxrwx 1 root root 10 Jan 11 16:25 14e97f7a-382e -> ../../dm-0

In this case, both devices map to ``dm-0``, so we want ``14e97f7a-382e``. We
then find the same for the boot partition ``Root-Boot``.

EFI Partition
~~~~~~~~~~~~~

If we are installing to an EFI system (most modern computers), we also need to
make note of the `UUID` of the EFI partition. The bootstrap process creates one
on each disk, so pick one that maps maps to the second partition of a disk::

  user@livecd > ls -l /dev/disk/by-uuid
  lrwxrwxrwx 1 root root 10 Jan  3 10:01 03E4-445B -> ../../sda2

``03E4-445B`` is suitable, as it maps to the second partition of a disk (i.e.
ends in ``2``).

Ansible
+++++++

The remainder of the setup will be accomplished using Ansible.

Configuration
-------------

First, the machine's `hostname` must be added to the ``bootstrap`` group in
``hosts``::

  [bootstrap]
  hostname

Then, a corresponding ``.yml`` file should be created in ``host_vars``. It
should contain the following section::

  filesystems:
    - uuid: 14e97f7a-382e
      mount: /
      filesystem: ext4
    - uuid: c50ee7f3-a8b4
      mount: /boot
      filesystem: ext4

The ``uuid`` is the one we made a note of in the previous section. If the system
is an EFI system (most modern ones are), we will need to add::

  efi_device: 03E4-445B

The ``efi_device`` is the UUID we made a note of earlier.

If it is a BIOS system, add the following instead::

  grub_devices:
    - /dev/disk/by-id/wwn-0x5e58
    - /dev/disk/by-id/wwn-0x5e9c
    - /dev/disk/by-id/wwn-0x5d1e

Each line should correspond to an installed disk (not partition) on the system.
You will have passed these to the ``bootstrap.sh`` script earlier.

Running
-------

Ansible should be invoked as follows::

  ansible-playbook bootstrap.yml --user user --ask-pass

This will perform the basic bootstrapping procedure - setting up networking, a
bootloader and SSH. If this completes without errors, the machine should be
restarted.

Then, the machine's `hostname` should be moved to the correct group in
``hosts``::

  [desktop]
  hostname

Afterwards, ansible should be run again, but with the ``local`` user, and
limited to the new machine::

  ansible-playbook site.yml --limit hostname --user local --ask-pass

.. [#disk-id] Paths in ``by-id`` will be stable across reboots.
.. [#duplicate-id] There may be duplicates, any one will do.
.. [#bootstrap] See the script for details on why Ansible was not used.

.. _`GRML`: https://grml.org
.. _`Debian Live`: https://www.debian.org/CD/live/
