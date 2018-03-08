Lab Computer Setup
==================

To date, only automated set-up of Linux computers has been implemented. These
fall into three major categories:

desktop
  Desktop machines with a GUI, mostly for personal use but with shared access.
  Intended for research, writing and simple programming tasks. May be Linux, OSX
  or Windows-based.

compute
  Shared servers, generally with more processing power than desktops. Intended
  to run programs on large datasets, and for shared use through remote desktop
  services. Linux only so far.

server
  Utility servers, for e.g. file sharing or user management. These should not be
  touched by most lab members. Linux only.


User Accounts
~~~~~~~~~~~~~

User information is saved in an :ref:`ldap-guide` directory. Authentication is
done using :ref:`kerberos-guide`. This allows a centralized passwords and
permissions system shared across all machines.

.. toctree::
   :maxdepth: 2
   :caption: Contents
   :glob:

   */index
