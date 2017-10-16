Lab IT Documentation
====================

This documentation provides a brief outline of how the lab computers are set-up.
Readers are referred to documentation of the programs used for additional
options and details.

Overview
--------

Two different types of devices are considered - lab computers, which are owned
and managed by the lab, and personal devices which need to connect to
file-sharing and remote desktop services.

All Computers
~~~~~~~~~~~~~

Authentication is managed using :ref:`kerberos-guide`. File storage is on a
centralized server (Delphi). For Linux clients, file access is via NFS, for OSX
via SAMBA_ and for Windows currently via WinSCP_ but in future it should also be
via SAMBA_.

Lab Computers
~~~~~~~~~~~~~

User information is saved in an :ref:`ldap-guide` directory. Set-up and
maintenance of all machines (only Linux implemented so far, but Windows is also
supported) is done with :ref:`ansible-guide`.

Linux
_____

Most lab computers are set up to run Debian Linux. This provides a free,
open-source environment that supports web-browsing, document processing and
computational environments including Python and MATLAB.

Windows
_______

No centralized management implemented yet.

OSX
___

No centralized management implemented yet.

.. _WinSCP: https://winscp.net/eng/index.php
.. _SAMBA: https://www.samba.org/

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   :glob:

   */index

Indices
=======

* :ref:`genindex`
* :ref:`search`
