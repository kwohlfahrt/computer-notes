SSH
===

The most common way to access a computer remotely is via `SSH` (secure shell)::

  > ssh user@computer.example.com

If your username is the same on both machines, ``user@`` may be omitted. See the
:ref:`Command-line Guide <command-line-guide>` for what to now.

The `tmux`_ tool is often used to allow commands to continue running in the
background after you have disconnected, and inspect their output later.

nice
++++

The ``nice`` command adjusts the priority of a command. If you plan to start a
long-running task on a remote computer, it is advisable to run it with a high
`niceness` value, so other people using the computer are not interrupted::

  > nice some_command --option

tmux
++++

The ``tmux`` (terminal multiplexer) command allows commands to continue running
even after you disconnect from a session. Starting tmux will open a new shell
where you can run commands as normal. A status-bar will be shown at the bottom
of the screen and should contain the following::

  [0] 0:fish*

Tmux can be controlled by pressing the prefix-key, and then entering instructions.
The prefix-key is usually set to ``Ctrl`` + ``b`` or ``Ctrl`` + ``a``.

Sessions
--------

The first number in the status bar (``[0]``) shows which tmux `session` you are
connected to. You can `detach` from a session by pressing the prefix key and
then ``d`` (detach). Now, you can start a new tmux session by running the
``tmux`` command again. The status bar should now show::

  [1] 0:fish*

You can list them all active sessions::

  > tmux list-sessions
  0: 1 windows ...
  1: 1 windows ... (attached)

To switch to a different session, detach from your current session. Then run::

  > tmux attach -t 0

to attach to session ``0``. If you omit the ``-t`` option, it will attach to the
most recently used session.

To close a session, quit all shells in the session.

Windows
-------

Following the session number in the status bar is the list of windows in that
session. To create a new window, use the prefix key then press ``c`` (create).
The status bar should now show two windows, the active one marked with ``*``::

  [0] 0:fish- 1:fish*

You can also list them manually::

  > tmux list-windows
  0: fish- ...
  1: fish* ... (active)

To switch between windows, use the prefix key, and ``n`` (next) or ``p``
(previous).

To close a window, quit all shells in that window.

Scrolling
---------

Tmux keeps a history of the output of your commands. To scroll up, press the
prefix key and then ``Page Up`` or ``Page Down``. To exit scrolling mode, press
``q``.

In scrolling mode, you can search for text in your history by pressing ``/`` to
search downwards or ``?`` to search upwards. This will allow you to enter your
search in the status bar. Pressing the ``n`` key will skip to the next match.
