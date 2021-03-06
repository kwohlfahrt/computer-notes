Networking
==========

This page contains some notes on low-level networking.


IP
--

On Linux, IP configuration is managed with the ``ip`` command. This can be set
to show IPv4 or IPv6 information with the ``-4`` and ``-6`` options
respectively.

Addresses
~~~~~~~~~

To list IP addresses, use the ``address`` command. By default, addresses will be
grouped by device::

  $ ip -6 address
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN qlen 1000
      inet6 ::1/128 scope host 
        valid_lft forever preferred_lft forever
  2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
      inet6 fe80::f6a0:49ff:fe2e:994c/64 scope link 
        valid_lft forever preferred_lft forever

To an IP address can be manually associated with a device using the ``add``
subcommand::

  $ ip address add fd10:11:12::1/64 dev eth0

The subnet (``/64``) affects the route that is implicitly added for each
address, if not given it defaults to ``/128``.

Routing
~~~~~~~

To inspect routes, use the ``route`` command::

  $ ip -6 route
  ::1 dev lo proto kernel metric 256 pref medium
  fd10:11:12::/64 dev eth0 proto kernel metric 256 pref medium
  fe80::/64 dev eth0 proto kernel metric 256 pref medium

This shows the implicit route inserted for the address added above.
