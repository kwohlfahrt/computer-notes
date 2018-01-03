.. _python-dev-guide:

Python Development
==================

This document is a quick summary of Python best practices, to set up consistent
software development inside the lab. It is not a guide to the Python programming
language. None of these rules are critical for small, personal projects, but
they are more useful to allow many people to contribute and use a single project
without getting in each others' way.

Organization
++++++++++++

Roughly, a project should be organized as shown below::

  project/
  ├── package_1/
  │   ├── large_module_1/
  │   │   ├── __init__.py
  │   │   ├── module_1.py
  │   │   └── module_2.py
  │   ├── __init__.py
  │   └── module_1.py
  ├── tests/
  │   ├── conftest.py
  │   ├── large_module_1/
  │   │   ├── __init__.py
  │   │   ├── test_module_1.py
  │   │   └── test_module_2.py
  │   ├── __init__.py
  │   └── test_module_1.py
  ├── .gitignore
  ├── .travis.yml
  ├── README.md
  ├── MANIFEST.in
  ├── setup.py
  └── setup.cfg

A project usually contains one package, with the same name
as the project itself. This should be placed in a subfolder to simplify
packaging (see `Setup`_ below). Individual files should be kept relatively
short, i.e. a few hundred to one-thousand lines.

Setup
+++++

Setuptools should be used for all projects, so they can be simply installed and
updated with `pip`_. A ``setup.py`` files looks like this::

  #!/usr/bin/env python

  from setuptools import setup

  setup(
      name="Project Name",
      version="0.0.1",
      description="What the program does",
      install_requires=[
        'other_package_1',
        'other_package_2>=0.2,<1.5'
      ],
      packages=['package_1'],
  )

If you wish to include non-Python files in your project, you should add the
following line to ``setup.py``::

  include_package_data=True, # If you have non-python files to install

Then, you need to create a ``MANIFEST.in`` file containing the names of files to
include. For example, to include a configuration file, and all ``.qml`` files::

  include package/configuration.conf
  recursive-include package *.qml

If your project contains command-line or graphical programs, they should be
specified as entry-points in ``setup.py``::

  entry_points={
    'console_scripts': [
      'command=package_1.module_1:function_1',
      'command=package_1.module_1:function_2',
    ],
  },

Graphical programs should use ``"gui_scripts"`` in place of
``"console_scripts"``. The function used should have the following format::

  def function_1(argv=None):
    import sys
    if argv is None:
      argv = sys.argv[1:]
    ...

Testing
+++++++

Projects should be tested with simple test cases as often and as early as
possible. This usually requires creating some fake minimal data. If it is not
possible to easily verify that the result is correct, the expected output should
be saved and validated in the tests. This at least verifies that the output of
the program is consistent and deterministic.

Tests should be placed in a separate folder, so they are not distributed with
the package. The layout of this folder should mirror the main package, with
subfolders for each module and one test file for each python file. The filename
and test function must begin with ``test_``. A sample test looks like this::

  def test_add():
    assert (2 + 2) == 4

To run tests, run the ``pytest`` command (or ``pytest-3`` for Python 3).

If you are using `numpy`_ arrays, you will probably need to use the utility
functions in ``numpy.testing``.

Coverage
--------

When tests are used, the test coverage should be checked too.

Pytest has built-in coverage support. The package for which coverage information
should be collected must be specified, for example ``pytest --cov=package_1``.

Advanced Features
-----------------

Pytest comes with a number of useful features, to make life easier.

Parametrization
~~~~~~~~~~~~~~~

Tests may be parametrized, so they run multiple times::

  @pytest.mark.parametrize("a, b, expected", [
    (1, 2, 3), (4, 6, 10)
  ])
  def test_add(a, b, expected):
    assert (a + b) == expected

This runs the test twice, once on each set of inputs provided.

Fixtures
~~~~~~~~

Some functions may not be tests themselves, but instead are fixtures to set up
the correct environment for the test. For example, to create a temporary
directory::

  @pytest.fixture
  def tmpdir():
    import tempfile

    d = tempfile.TemporaryDirectory()
    yield d
    d.cleanup()

  def test_thing(tmpdir):
    import os
    assert len(os.listdir(d.name)) == 0

This ensures the temporary directory is created for each test, and cleaned up
afterwards. By default, a test fixture is created and destroyed after each test
function. If it should last longer, this can be achieved by setting the scope
(e.g. ``pytest.fixture(scope="module")``).

Fixtures may themselves take fixtures as inputs. They can be defined in
``conftest.py`` or in the same file as the test.

Formatting
----------

To make it easy to switch between projects, `flake8`_ is used. This makes sure
formatting is consistent thoughout various projects. It can be run through
pytest ``pytest --flake8``. This allows ignored warnings to only be configured
on a per-directory basis, a feature not provided by flake8 itself.

Exceptions can be configured in ``setup.cfg``, the following is recommended:

.. code-block:: ini

  [tool:pytest]
  flake8-ignore =
    E129
    tests/*.py F403 F405
  flake8-max-line-length = 90

Exceptions can also be added in comments beginning with ``noqa:`` for example::

  from foo import *  # noqa: F403, F405

.. _pip: https://pip.readthedocs.io/en/stable/
.. _numpy: https://docs.scipy.org/doc/numpy/
.. _flake8: http://flake8.pycqa.org/en/latest/
