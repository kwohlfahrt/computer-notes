Printers
========

Printers can be a pain to set up with Linux, as each manufacturer has its own
drivers, which are not always compatible. Generally, you will need `CUPS`_, the
`Common Unix Printing System` installed.

HP
--

HP printers require the ``hplip`` package.

Network Printers
~~~~~~~~~~~~~~~~

First, find the IP address of the printer. This should be displayed somewhere on
the printer. We will call this ``<printer-ip>``.

Then generate the driver-specific URIs::

  > hp-makeuri <printer-ip>
  HP Linux Imaging and Printing System (ver. 3.18.5)
  Device URI Creation Utility ver. 5.0

  Copyright (c) 2001-15 HP Development Company, LP
  This software comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to distribute it
  under certain conditions. See COPYING file for more details.

  CUPS URI: hp:/net/HP_SomePrinter?ip=<printer-ip>
  SANE URI: hpaio:/net/HP_SomePrinter?ip=<printer-ip>
  HP Fax URI: hpfax:/net/HP_SomePrinter?ip=<printer-ip>

  Done.

Make a note of the ``CUPS URI`` (``hp:/net/HP_SomePrinter?ip=<printer-ip>``),
which will be called ``<uri>``. Also pick a name for the printer (``<name>``).

You may need to select a driver for your model of printer. To view all models,
run::

  > lpinfo -m
  drv:///sample.drv/laserjet.ppd HP LaserJet Series PCL 4/5
  drv:///sample.drv/epson9.ppd Epson 9-Pin Series

Each line consists of a driver file, followed by a description - pick the file
(``drv:///sample.drv/laserjet.ppd``) that best matches your printer, which will
be called ``<model>``.

Finally, add the printer to CUPS. This can be done via the web interface at
``localhost:631``, or the command line interface::

  lpadmin -p <name> -v <uri> -m <model> -E

There are various other options to add human-readable descriptions to the
printer.

To list all printers::

  > lpstat -p -d
  printer laserjet is idle.  enabled since Thu 20 Sep 2018 11:06:23 BST
  no system default destination

The default printer can be set with::

  > lpoptions -d <name>

To delete the printer::

  > lpadmin -x <name>

.. _CUPS: https://www.cups.org
