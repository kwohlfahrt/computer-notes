.. _github-guide:

Github
======

Github_ provides many useful features on top of just hosting git repositories,
these are outlined here.

Features
++++++++

Pull Requests
-------------

Pull requests are requests to merge changes from one repository or branch into
another. This provides a convenient location to discuss the changes before
merging them to an official repository. Often, third-party tools integrate with
pull requests (see `Tools`_) to further improve their usefulness.

Issue Tracking
--------------

Issues, such as bugs and feature requests can be tracked on Github. This
provides a centralized list of open issues where they can be discussed and
clarified. They can also be assigned to people, or marked with different tags to
keep track of the most urgent ones.

Reporting a Bug
~~~~~~~~~~~~~~~

A bug-report is likely to be addressed if it provides all the relevant
information. This usually includes the following:

- What version were you using?

  If it is not the latest version, try that first - the bug may already be
  fixed.
- What did you do?
   
  What is the exact command you ran, or the sequence of buttons you pressed?
  What files did you run the command on?
- What did you expect?

  What was the outcome you expected after the actions above?
- What happened instead?

  How did that differ from what you expected? Try to include any error messages
  at this point.

Tools
+++++

This section describes some useful third-party tools that integrate with Github,
and how to set them up.

Testing
-------

Automated tests are recommended to test the functionality of your program in a
standardized way, and also to check your installation procedurre. `Travis-CI`_
is the most common testing platform for github.

For instructions on how to write tests for Python programs, see
:ref:`python-dev-guide`.

To enable Travis for your project, follow the instructions below.

1) At the `Travis-CI`_ web page, click "Sign in with GitHub".
2) Click the profile icon (top right)
3) Enable the repositories you want to test
4) Create a ``.travis.yml`` file as described in `Configuration`_
5) Upload these changes to Github

Configuration
~~~~~~~~~~~~~

Travis is set-up via a file name ``.travis.yml`` in the top-level folder of your
project. It has roughly the following format:

.. code-block:: yaml

  language: <language>
  <language>:
    - <version>
    - <version>
  install:
    - <install command>
    - <install command>
      ...
  script:
    - <test command>
    - <test command>
      ...

This runs the install commands (in order), followed by the test commands for
each version of the language. For language-specific instructions, see the
`Travis documentation <https://docs.travis-ci.com/>`_.

To run a one-off test (e.g. only with a single version of the language), the
build matrix can be customized by adding:

.. code-block:: yaml

  matrix:
    include:
      - <language>: <version>
        install:
          ...
        script:
          ...

This is useful for version independent tests, such as formatting checkers like
flake8 for Python.

Coverage
--------

Seeing that all tests pass is not very informative if it only tests a small
subset of your program's functionality. It is also necessary to `Codecov`_ is a
useful platform that summarizes the results of these checks.

For instructions on how to set up test coverage for Python programs, see
:ref:`python-dev-guide`.

To enable Codecov for your project, click "Log In" at the `Codecov`_ website.
There is no need to enable individual projects, this is done automatically when
a report is uploaded.

To upload a report from Travis, the correct command must be run after the tests
have successfully completed. This is done by adding a section like the one below
to ``.travis.yml``:

.. code-block:: yaml

  after_success:
    - <command>

The exact command will vary depending on the language being used, see the other
guides or the `Codecov documentation <https://docs.codecov.io/docs>`_.

.. _Github: https://github.com
.. _Travis-CI: https://travis-ci.org
.. _Codecov: https://codecov.io
