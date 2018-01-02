.. _git-guide:

Git
===

This document is an overview of the git_ version control system. Read the
`Concepts`_ section for an overview, or skip to `Workflow`_ to get started.
Examples use the command-line interface to git, but some editors such as `Visual
Studio Code`_ or `Emacs`_ provide simpler interfaces to git. Best practices for
working with Github_ are described in the :ref:`github-guide`.

Concepts
++++++++

Remotes
-------

Git is a distributed version control system, meaning that every developer has a
full copy of the code (unlike for example `SVN`_). A central repository, often
hosted on Github_ may be chosen for convenience, but is not necessary.

Each repository may have a number of "remotes", i.e. other copies of the same
code. Traditionally, the location the code is downloaded from is given the name
"origin". To list the current remotes, run ``git remote show``. To show detailed
information about a remote, run ``git remote show <name>``.

To add a new remote, use ``git remote add <name> <url>``. The URL can take many
forms, as described in `Cloning`_.

An existing remote can be renamed with ``git remote rename <old> <new>``, and
the URL remote can be changed with ``git remote set-url <name> <url>``.

Commits
-------

A project is a series of commits, each of which contains some changes to the
files in the project and a short message describing the changes.

Branches
--------

A project may contain multiple branches, for example it may contain a branch for
each released version, or each feature currently in development. Commits can be
added to branches individually, and merged later. This makes it possible to for
example fix bugs in released versions without impacting other development.
Traditionally, the main branch is called "master".

Workflow
++++++++

To start a new project, run ``git init`` in the folder containing your code. To
work on an existing project, see `Cloning`_.

Cloning
-------

To download a copy of an existing project, use ``git clone <url>``. This can
take many forms, but the most common are:

HTTPS
  ``https://example.com/path/to/code.git``
SSH
  ``ssh://user@example.com/path/to/code.git`` or
  ``user@example.com/path/to/code.git``
Local Folders
  ``/path/to/code.git`` or ``file:///path/to/code.git``

This creates a folder for the project, and downloads the files from the URL
provided, storing them as a remote (see `Remotes`_) named "origin".

Updating
--------

Downloading
~~~~~~~~~~~

To download changes from a remote repository, run ``git pull <remote>``.

Uploading
~~~~~~~~~

To upload changes you have made to a remote repository (see `Adding Changes`_),
run ``git push <remote>``.

Adding Changes
--------------

Adding changes is a two-step process with git.

Staging
~~~~~~~

To show a summary of what changes you have made since the last commit, run ``git
status``. To view the changes, run ``git diff``.

To add the changes you have made to a file, run ``git add <filename>``. These
commands add your changes to the staging area. To review the changes you have
added to the staging area, run ``git diff --cached``.

To unstage the changes you have made to a file, run ``git reset HEAD
<filename>``. To undo any changes you have not staged, run ``git checkout
<filename>``.

Most commands in this section take a ``--patch`` option, (e.g. ``git
checkout --patch <filename>``), which will prompt you whether to apply to each
individual section of a file.

Committing
~~~~~~~~~~

When you are happy with the changes in the staging area, commit them with ``git
commit``. This will prompt you to write a description of the changes, and then
create a commit containing the message and the changes. These changes can now be
pulled from your repository, or pushed to a remote repository (see `Updating`_).


.. _git: https://git-scm.com/
.. _Github: https://github.com
.. _git-clone: https://git-scm.com/docs/git-clone
.. _Visual Studio Code: https://code.visualstudio.com/
.. _Emacs: https://www.gnu.org/software/emacs/
.. _SVN: https://subversion.apache.org/
