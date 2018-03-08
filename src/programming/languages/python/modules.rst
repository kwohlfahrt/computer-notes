.. _python-modules:

Modules
=======

To make working with large Python projects easier, code may be split over
multiple files. Each file is called a `module`. Python comes with a number of
useful built-in modules, collectively called the `standard library <stdlib_>`_.

Creating
++++++++

A module is simply a file containing Python code, and ending in ``.py``. For
example, if I place the following in a file called ``parrot.py``::

  required_volts = 4000000

  def voom(volts):
      return volts > required_volts

Any values defined in this file (including `imported values <Importing_>`_) are
accessible. I have created a module ``parrot``, containing two variables: the
value ``required_volts`` and the function ``voom``.

A folder containing multiple modules is also itself a module. For example, a
folder ``circus`` might contain ``parrot.py`` and a folder ``joke``, containing
``english.py`` and ``german.py``. This creates five modules: ``circus``, its
sub-modules ``circus.parrot`` and ``circus.joke``, and the sub-sub-modules
``circus.joke.english`` and ``circus.joke.german``.

__init__.py
-----------

If a module-folder should also contain values other than sub-modules, these must
be defined in a file named ``__init__.py``. You may import values from other
modules inside ``__init__.py``. Python does not require this file, but some
tools do so you may wish to include it even if it is empty.

Using
+++++

There are two ways to use a module. They can be run directly, or imported for
use in a different module.

Importing
---------

To use a value defined in a module, they can be imported. The values contained
in a function are accessible as its attributes. For example, the standard
library defines the ``datetime`` module::

  >>> import datetime
  >>> apocalypse = datetime.date(2012, 12, 21)
  >>> today = datetime.date.today()

You can also import values from a particular module::

  >>> from datetime import date
  >>> today = date.today()

Multiple imports are separted by commas::

  >>> import os, sys
  >>> from datetime import date, timedelta

Modules can be nested, for example the function ``join`` from the module
``os.path`` can be accessed in a few ways::

  >>> import os
  >>> os.path.join
  <function join at 0x...>
  >>> from os.path import join
  >>> join
  <function join at 0x...>

Note you cannot do this with ``today`` on ``date`` - ``date`` is a `type`, not a
module::

  >>> from datetime.date import today
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ModuleNotFoundError: No module named 'datetime.date'; 'datetime' is not a package

Relative
~~~~~~~~

The imports shown so far are absolute, that means they are relative to a few
pre-defined locations (and the current folder of the terminal) [#path]_. Imports
relative to the current module can be specified by beginning with a ``.``. For
example, to import the module ``circus.joke`` from ``circus.parrot``::

  >>> from . import joke

If ``joke`` contained two sub-modules, ``german`` and ``english``, you could
then do::

  >>> from .joke import german

Two dots (``..``) moves one level up the hierarchy. So inside ``german.py`` you
could import ``parrot``::

  >>> from .. import parrot

or::

  >>> from ..parrot import voom

You cannot move further up than the top-level module.

Running
-------

A python module can be run much like a python script, the following are
nearly equivalent::

  > python parrot.py
  > python -m parrot

Nested modules are separated by ``.`` symbols. So in the parent directory of
``circus``, you could do either of these::

  > python circus/parrot.py
  > python -m circus.parrot

Running a file as a module (with ``-m``) rather than as a script has the
advantage that you can use `relative imports <Relative_>`_.

.. [#path] Specifically, the locations in ``sys.path``, which you can import and
   modify.

.. _stdlib: https://docs.python.org/3/library/index.html
