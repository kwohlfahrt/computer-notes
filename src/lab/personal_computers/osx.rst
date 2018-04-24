OSX
===

This document is about connecting Apple computers running OSX.

DNS
---

To configure DNS, follow the steps below.

1. Open `System Preferences` → `Network`
2. `Location` → `Edit Locations` → `Add` (`+`)
3. Pick a name for the new location, and select it
4. `Advanced` → `DNS`
5. Set `DNS Servers` to (in order):

   1. ``172.25.122.83``
   2. ``131.111.8.42``
   3. ``131.111.12.20``

6. Set `Search Domains` to (in order):

   1. ``edl1.bioc.private.cam.ac.uk``

When connecting to the lab computers (through eduroam or the VPN service), you
will need to activate this location. To use the internet outside of the
university, you should switch back to your previous location (probably
`Automatic`).

Kerberos
--------

To set up Kerberos, you need to copy the provided configuration file to your
computer.

1. Open `Finder`
2. `Go` → `Go to Folder`
3. Enter ``/etc`` as the location. This is where the file will be copied to.

Now, open a new Finder window and follow steps 1-3 of the `Network Files`_
guide, then continue as described here:

4. Select `Guest`
5. Select the ``public`` share
6. Copy ``krb5.conf`` into the window opened in step 3 above

Kerberos is now set up. Before connecting again, you should disconnect from the
guest login. The server can be found in the sidebar of Finder, under `Shares` -
click the eject symbol.

Network Files
-------------

Networked files are shared over `Samba`_. For access to shares other than
``public``, you must first set up `Kerberos`_. They can be accessed with the
following steps:

1. Open `Finder`
2. `Go` → `Connect to Server`
3. Enter the following location: ``smb://delphi.edl1.bioc.private.cam.ac.uk/``
4. Select `Registered User` and enter your lab user-name and password
5. Select the ``home`` share for current files, or ``archive`` for historic backups.
   The server should now be visible in the sidebar (View → Show Sidebar).

.. todo::
   Work out how to prevent Samba from generating ``._*`` files. Can't just
   blacklist them as this may break things.

.. todo::
   Work out how to let users modify file permissions. This works on some Macs
   currently.

.. _Samba: https://www.samba.org/
