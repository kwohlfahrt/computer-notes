.. _git-branches:

Branches
========

A project may contain multiple branches, for example a branch for each released
version, or each feature currently in development. Commits can be added to
branches individually, and merged later. Traditionally, the main branch is
called "master". Additionally, the currently checked out branch has the special
name "HEAD". When referring to branches in a remote repository, they are
separated by a forward slash (e.g. ``origin/master`` refers to the branch
``master`` at the remote ``origin``)

We continue where we left off in the introduction, with ``project`` (and its
remote "downstream").

Creating
++++++++

To create a new branch, use ``git branch <name> <commit>`` (if ommitted,
``<commit>`` will be ``HEAD``)::

  > git branch tmp master

``<commit>`` may refer to a branch on a remote as well, e.g.
``downstream/master``.

To list the branches, use ``git branch --list`` (with ``--all`` to include
remotes)::

  > git branch --list --all
  * master
  tmp
  remotes/downstream/master

an existing branch, run ``git branch <new> <existing>``. The existing branch may
be in a remote repository, e.g. ``git branch testing origin/testing``.

Checking-out
------------

A branch can be checked out like any other commit, so to switch to a branch::

  > git checkout tmp
  Switched to branch 'tmp'
  > git status
  On branch tmp
  nothing to commit, working tree clean

Commits
+++++++

Branches can be modified independently of each other. The following section adds
a different new line to ``todo.txt`` in both branches::

  > echo '- commit to a branch' >> todo.txt
  > git add todo.txt
  > git commit -m "add branch todo"
  [tmp 81704d1] add branch todo
   1 file changed, 1 insertion(+)
  > git checkout master
  > echo '- read a book' >> todo.txt
  > git add todo.txt
  > git commit -m "add fun todo"
  [master 8a69fee] add fun todo
   1 file changed, 1 insertion(+)

Note each commit summary shows what branch it has been added to. To get a visual
display of the state of our branches, use ``git show-branch``::

  > git show-branch
  ! [master] add fun todo
   * [tmp] add branch todo
  --
   * [tmp] add branch todo
  +  [master] add fun todo
  +* [tmp^] Add todo

Combining
+++++++++

There are two ways to combine existing branches - `rebasing <Rebasing>`_ and
`merging <Merging_>`_.

Rebasing
--------

Rebasing changes what commit the current branch is based on. ``git rebase <base>
<branch>``::

  > git rebase master tmp
  > git show-branch
  ! [master] add fun todo
   * [tmp] add branch todo
  --
   * [tmp] add branch todo
  +* [master] add fun todo

As you can see, the changes in ``tmp`` are now applied after the commits in
master. Unfortunately, this will not work on our current directory, as we have
changed the same part of the same file in both branches. See `Conflict
Resolution`_ below for information on how to resolve this.

The ``--interactive`` option lets you edit which changes will be included, this
lets you edit the history of a branch by rebasing onto an earlier version of
itself. For example ``git rebase --interactive master~5 master`` will let you
edit any of the previous 5 commits.

Merging
-------

To incorporate changes from different branches into the current branch, use
``git merge <branches>`` (you can also refer to specific commits)::

  > git checkout master
  > git merge tmp
  Updating 9414ca8..f687246
  Fast-forward
   todo.txt | 1 +
   1 file changed, 1 insertion(+)
  > git show-branch
  * [master] add branch todo
   ! [tmp] add branch todo
  --
  *+ [master] add branch todo

Because "tmp" was rebased onto master, git can use the `fast-forward` merge
strategy where the commits in that branch are simply applied to the base.

If we disable this (with ``--no-ff``) or have a more complicated merge that
requires conflict resolution, git will create an explicit merge commit::

  > git show-branch
  * [master] Merge branch 'tmp'
   ! [tmp] add branch todo
  --
  -  [master] Merge branch 'tmp'
  *+ [tmp] add branch todo

This does not delete the branch, and commits can still be added to it for later
merging::

  > git branch --list
  * master
  tmp

Conflict Resolution
-------------------

Merging and rebasing may result in an error if the changes made in the two
branches conflict. The conflict will be presented as shown below:

.. code-block:: none

   - learn git
   <<<<<<< HEAD
   - read a book
   =======
   - commit to a branch
   >>>>>>> add branch todo

This shows the changes made in the conflicting commits, separated by a row of
``=``, and bounded by ``<`` and ``>`` respectively. The file must be manually
edited to the desired state and added to the index before continuing. After
resolving the conflict, run ``git rebase --continue`` (or ``git merge
--continue``) to proceed.

If the merge is too complicated, ``git merge --abort`` or ``git rebase --abort``
resets your files to the state they were in before the attempted merge.

Deleting
++++++++

To delete a branch, use ``git branch --delete <branch>``::

  > git branch --delete tmp
  Deleted branch tmp (was f687246).

If your branch has not been merged, you may need to specify ``--force`` as well.

Remotes
+++++++

A branch can be `remote-tracking`, which means it will pull and push to a
specific remote branch by default::

  > git branch --set-upstream-to downstream/master master
  Branch 'master' set up to track remote branch 'master' from 'downstream'.

Git will also keep you up to date on the status of your branch compared to the
remote::

  > git status
  On branch master
  Your branch is ahead of 'downstream/master' by 3 commits.
    (use "git push" to publish your local commits)

  nothing to commit, working tree clean

Stashing
++++++++

Merging and rebasing require a clean working directory (i.e. no changes to any
files). To store your current changes, use ``git stash``. ``git stash --list``
lists the current sets of stashed changes. ``git stash apply <stash>`` can then
be used to re-apply these changes later, or ``git stash drop <stash>`` to forget
them.

Garbage Collection
++++++++++++++++++

Frequent merging and rebasing can lead to an increase in the size of the
repository. You can reclaim some disk space with the ``git gc`` (garbage
collect) command. The reason this is not done automatically is that it is
normally possible to recover accidentally deleted commits - ``git gc``
permanently deletes them.
