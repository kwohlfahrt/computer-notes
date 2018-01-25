.. _git-branches:

Branches
--------

A project may contain multiple branches, for example a branch for each released
version, or each feature currently in development. Commits can be added to
branches individually, and merged later. Traditionally, the main branch is
called "master". Additionally, the currently checked out branch has the special
name "HEAD". When referring to branches in a remote repository, they are
separated by a forward slash (e.g. ``origin/master`` refers to the branch
``master`` at the remote ``origin``)

To list the branches, use ``git branch --list``. To create a new branch based on
an existing branch, run ``git branch <new> <existing>``. The existing branch may
be in a remote repository, e.g. ``git branch testing origin/testing``. To switch
to a branch, use ``git checkout <branch>``.

For example, after creating the branch ``feature`` from ``master``, commits can
be independently added to both branches:

.. image:: images/branch.svg
   :align: center
   :height: 64

To delete a branch, use ``git branch --delete <branch>``.

Rebasing
~~~~~~~~

Rebasing changes what commit the current branch is based on. ``git rebase <base>
<branch>`` inserts the changes in "base" before those of "branch".

.. image:: images/rebase.svg
   :align: center
   :height: 64

The ``--interactive`` option lets you edit which changes will be included, this
lets you edit the history of a branch by rebasing onto an earlier version of
itself. For example ``git rebase --interactive master~5 master`` will let you
edit any of the previous 5 commits.

Merging
~~~~~~~

To incorporate changes from different branches into the current branch, use
``git merge <branches>`` (you can also refer to specific commits).

.. image:: images/merge.svg
   :align: center
   :height: 64

This does not delete the branch, and commits can still be added to it for later
merging.

Conflict Resolution
~~~~~~~~~~~~~~~~~~~

Merging and rebasing may result in an error if the changes made in the two
branches conflict. The conflict will be presented as shown below:

.. code-block:: none

  ...
  Here is some surrounding text.

  <<<<<<< yours:sample.txt
  Conflict resolution is hard;
  let's go shopping.
  =======
  Git makes conflict resolution easy.
  >>>>>>> theirs:sample.txt

  The text continues here.
  ...

If this occurs, the file needs to be manually edited and added, before
continuing. Once the conflict is resolved, run ``git rebase --continue`` (or
``merge``) to proceed. If the merge is too complicated, ``git merge/rebase
--abort`` resets your files to the state they were in before the merge.

Stashing
--------

Merging and rebasing require a clean working directory (i.e. no changes to any
files). To store your current changes, use ``git stash``. ``git stash --list``
lists the current sets of stashed changes. ``git stash apply <stash>`` can then
be used to re-apply these changes later, or ``git stash drop <stash>`` to forget
them.

Garbage Collection
------------------

Frequent merging and rebasing can lead to an increase in the size of the
repository. You can reclaim some disk space with the ``git gc`` (garbage
collect) command. The reason this is not done automatically is that it is
normally possible to recover accidentally deleted commits - ``git gc``
permanently deletes them.
