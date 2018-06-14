Ubuntu Setup
============

DNS
---

To configure DNS, follow the steps below.

1. Open `System Settings` → `Network`
2. View the network you use in the lab (right arrow)
3. Press `Settings`
4. Go to `IPv4 Settings`
5. Set `Method` to ``Automatic (DHCP) addresses only``
6. Set `DNS Servers` to (in order):

   1. ``172.25.122.83``
   2. ``172.25.122.90``
   3. ``131.111.8.42``
   4. ``131.111.12.20``

6. Set `Search domains` to (in order):

   1. ``edl1.bioc.private.cam.ac.uk``

7. Press `Save`

To test the DNS setup, run ``ping -c3 delphi``.

.. note:: dnsmasq

   Some versions of Ubuntu use dnsmasq with NetworkManager. This must be
   disabled by removing the line ``dns=dnsmasq`` from
   ``/etc/NetworkManager/NetworkManager.conf``.

Kerberos
--------

1. Install the ``krb5-user`` package.
2. Open the file ``/etc/krb5.conf`` and set the following content::

     [libdefaults]
       default_realm = EDL1.BIOC.CAM.AC.UK
       dns_canonicalize_hostname = false
       forwardable = true
       proxiable = true

     [realms]
       EDL1.BIOC.CAM.AC.UK = {
         kdc = delphi.edl1.bioc.private.cam.ac.uk
         kdc = minos.edl1.bioc.private.cam.ac.uk
         admin_server = delphi.edl1.bioc.private.cam.ac.uk
       }

     [domain_realm]
       .edl1.bioc.private.cam.ac.uk = EDL1.BIOC.CAM.AC.UK
       edl1.bioc.private.cam.ac.uk = EDL1.BIOC.CAM.AC.UK

NFS
---

In this section, we use the following definition:

``<machine>``
  A memorable name for the user's computer (e.g. its host-name or the owner's
  CRSID).

1. Install the package ``nfs-common-1.3.4`` or newer.
2. Add the following line to ``/etc/fstab``::

     delphi.edl1.bioc.private.cam.ac.uk:/home /mnt/delphi nfs rw,user,exec,nfsvers=4.2 0 0

3. Add a principal of the form ``host/<machine>`` to Kerberos
4. Create a keytab with the above principal in ``/etc`` on the user's computer

You should now be able to mount the network share by running ``mount
/mnt/delphi``.
