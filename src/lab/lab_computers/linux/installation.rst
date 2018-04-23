Installation
============

This document covers the installation of Debian Linux and set-up of a new
computer. A command prompt will always be shown as ``username@hostname``, pay
close attention to which user should run the command and which host it should be
run on.

Computers are named as follows:

``livecd``
    The new machine, runnning a live-CD
``new_computer``
    The new machine, running its newly installed system
``adminpc``
    The existing admin machine, which runs Ansible and SSH

Users are:

``root``
  The root user (i.e. run the command with ``sudo``)
``live``
  The unprivileged account of the Live-CD
``local``
  The user account literally named ``local``, created on the new system
``admin``
  The user of the administrator on an existing computer

Requirements
++++++++++++

The system must have a network connection and be running a Linux variant that
contains `bash` and `apt`. The `GRML`_ or `Debian Live`_ USBs are recommended.

You must also install and start an ssh server if it is not included by default::

  root@livecd> apt update
  root@livecd> apt install openssh-server
  root@livecd> systemctl start ssh

To check if SSH is running, check for ``Active: active`` status::

  live@livecd> systemctl status ssh
  ● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since ...
     ...

To establish an SSH connection, you will need to make a note of the IP address::

  live@livecd> ip addr
  1: eth0: ...
      inet 172.25.122.100/24 brd 172.25.122.255 scope global ...
      ...

The correct IP address is of type ``inet`` and scope ``global``, so here it is
``172.25.122.100``.

Then, you must find the IDs of the disks you plan to use for data and (optional)
cache::

  live@livecd> lsblk
  NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
  sda      8:0    0   1.8T  0 disk 
  sdb      8:16   0 931.5G  0 disk 
  sdc      8:32   0 447.1G  0 disk 

These should be paths that start with ``/dev/disk/by-id`` [#disk-id]_, so we
find these paths [#duplicate-id]_::

  live@livecd> ls -l /dev/disk/by-id
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5d1e -> ../../sda
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5e9c -> ../../sdb
  lrwxrwxrwx 1 root root  9 Jan  3 10:01 wwn-0x5e58 -> ../../sdc

Bootstrap
+++++++++

Shell scripts [#bootstrap]_ are provided to bootstrap the system, they are
located in the ``bootstrap`` directory. All hard disks to be used must be passed
as command-line arguments. Copy the directory over to the new machine::

  user@adminpc> scp -r bootstrap live@livecd:/tmp/

.. Warning:: The following step will wipe all of the specified disks.

And then run it (on the remote machine). Specify your LiveCD username with the
``--user`` option (defaults to ``user``). Two modes are available:

btrfs
  partition and install for a BTRFS filesystem. This is good for NFS storage
  servers.
lvm
  partition and install for LVM. This is good for desktops and provides the
  ``--cache`` option to specify SSD(s) to use as a hard-disk cache.

For details, run ``bootstrap.sh --help``.

For example, to install a desktop machine with one cache drive::

  root@livecd> /tmp/bootstrap/bootstrap.sh --user live lvm
  --cache /dev/disk/by-id/wwn-0x5e58 /dev/disk/by-id/wwn-0x5e9c

Or to install an NFS server with two disks::

  root@livecd> /tmp/bootstrap/bootstrap.sh --user live btrfs
  /dev/disk/by-id/wwn-0x5e58 /dev/disk/by-id/wwn-0x5e9c

This step will take up to half an hour. At the end, it will prompt for a
password, this will be used for the ``local`` account on the new machine.

.. Note:: This script sets up a chroot jail for SSH, so keep one or more
          connections open in case of errors.

This will leave us with a usable system we can `chroot` into in ``/mnt``.

.. Warning:: The system is not yet bootable, so do not restart the computer.

Centralized Setup
+++++++++++++++++

DNS
---

The new machine must be added to the lab DNS setup. This should be done by
adding to ``roles/storage/files/bind/db.edl1`` a line of the form::

  new_computer  IN A  172.25.122.100

Where the first item is the desired hostname of the new machine, and the last is
the IP of the new machine. Then, ansible should be run to propagate this setting
to the DNS machine (DNS currently shares the ``storage`` role)::

  admin@adminpc> ansible-playbook site.yml --limit localhost,storage

.. Attention:: Skip this command if you are setting up the DNS server itself.

Ansible
+++++++

The remainder of the setup will be accomplished using Ansible.

Configuration
-------------

First, the machine's `hostname` must be added to the ``bootstrap`` group in
``hosts``::

  [bootstrap]
  new_computer

Then, a corresponding ``.yml`` file should be created in ``host_vars``. It will
contain information about the file-systems on the machine.

First we have to find the `UUID` of the root and boot file-systems. These must
map to the same devices as ``Root-Data`` and ``Root-Boot`` in ``/dev/mapper``
respectively::

  live@livecd> ls -l /dev/mapper
  lrwxrwxrwx 1 root root       7 Jan 11 16:25 Root-Data -> ../dm-5
  lrwxrwxrwx 1 root root       7 Jan 11 16:25 Root-Boot -> ../dm-4
  live@livecd> ls -l /dev/disk/by-uuid
  lrwxrwxrwx 1 root root 10 Jan 11 16:25 14e97f7a-382e -> ../../dm-5
  lrwxrwxrwx 1 root root 10 Jan 11 16:25 c50ee7f3-a8b4 -> ../../dm-4

In this case, the ``filesystems`` section should look as follows::

  filesystems:
    - uuid: 14e97f7a-382e
      mount: /
      filesystem: ext4
    - uuid: c50ee7f3-a8b4
      mount: /boot
      filesystem: ext4

Next, we need to configure the bootloader partition. Follow instructions in `EFI
Partition`_ if the system is an EFI system (most modern devices are), or follow
`GRUB Devices`_ if not. If you are unsure, check if the directory
``/sys/firmware/efi`` exists; if it does, it is an EFI system.

EFI Partition
~~~~~~~~~~~~~

We need to make note of the `UUID` of the EFI partition. The bootstrap process
creates one on each disk, so pick any one that maps maps to the second partition
of a disk::

  live@livecd> ls -l /dev/disk/by-uuid
  lrwxrwxrwx 1 root root 10 Jan  3 10:01 03E4-445B -> ../../sda2

``03E4-445B`` is suitable, as it maps to the second partition of a disk (i.e.
ends in ``2``).

We then need to add the following ``efi_device`` section::

  efi_device: 03E4-445B

GRUB Devices
~~~~~~~~~~~~

If it is a BIOS system, add the following instead::

  grub_devices:
    - /dev/disk/by-id/wwn-0x5e58
    - /dev/disk/by-id/wwn-0x5e9c
    - /dev/disk/by-id/wwn-0x5d1e

Each line should correspond to an installed disk (not partition) on the system.
You will have passed these to the ``bootstrap.sh`` script earlier.

Running
-------

First, make an SSH connection to the host under its new DNS name (this will add
its host key to the known hosts file)::

  admin@adminpc> ssh live@new_computer exit

Then, ansible should be invoked as follows::

  admin@adminpc> ansible-playbook bootstrap.yml --user live --ask-pass

The ``SSH password`` is the SSH password for the machine. The ``SUDO password``
is the password of the local account that you were prompted for in the
`Bootstrap`_ step.

This will perform the basic bootstrapping procedure - setting up networking, a
bootloader and SSH. This will take up to half an hour, mostly spent installing
packages. If it completes without errors, the machine should be restarted.

After restarting, you will probably need to clear your ssh `known hosts` (the IP
address should be that of the new computer) to connect::

  admin@adminpc> ssh-keygen -f ~/.ssh/known_hosts -R 172.25.122.100
  admin@adminpc> ssh-keygen -f ~/.ssh/known_hosts -R new_computer.edl1.bioc.private.cam.ac.uk
  admin@adminpc> ssh local@new_computer exit

Then, the machine's hostname should be moved to the correct group in ``hosts``::

  [desktop]
  new_computer

Afterwards, ansible should be run again, but with the ``local`` user, and
limited to the new machine::

  admin@adminpc> ansible-playbook site.yml --limit localhost,new_computer
  --user local --ask-pass

This may take around an hour, depending on the number of packages to be
installed.

.. [#disk-id] Paths in ``by-id`` will be stable across reboots.
.. [#duplicate-id] There may be duplicates, any one will do.
.. [#bootstrap] See the script for details on why Ansible was not used.

.. _`GRML`: https://grml.org
.. _`Debian Live`: https://www.debian.org/CD/live/
