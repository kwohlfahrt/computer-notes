.. _ansible-guide:

Ansible
=======

This page gives a quick overview of Ansible_. For a detailed manual, consult the
`Official Documentation`_

Ansible is a remote management tool. It does not require installation on the
computers being managed, instead the ansible tool contains modules that generate
commands which are run on the client computers via SSH or PowerShell.

.. _Official Documentation: http://docs.ansible.com/ansible/latest/index.html
.. _Ansible: https://www.ansible.com/

Management
----------

For remote management, Ansible runs "playbooks". This is a YAML file which
contains a list of tasks to apply to each host::

  ansible-playbook site.yml

Common arguments are

``--inventory=hosts`` or ``-i hosts``
  to specify the file that contains the inventory (a list of hosts), or a
  comma-separated list of hosts directly

``--ask-become-pass`` or ``-K``
  to prompt for an admin password. Otherwise passwordless ``sudo`` is required.

``--check`` or ``-c``
  to not execute any tasks, just print what would be executed.

Hosts
~~~~~

Each managed machine is a host. Hosts may be grouped into (possibly nested)
sites. The host can be by a resolvable name (for your SSH client), or by a
custom name with an annotation (e.g. ``jason ansible_host=example.com``).

Roles
~~~~~

Computers can be managed by assigning them to roles. Each role consists of a
set of role dependencies (e.g. the 'desktop' role might depend on the 'common'
role) and a list of tasks to be executed for the current role.

Tasks
~~~~~

Tasks may be executed directly, or as part of a role. A task is a single action
that corresponds to an ansible module, e.g. a task using the ``apt`` module might
install a particular package from the Debian repositories.

A task produces one of three results:

``ok``
  the task ran successfully but caused no change (e.g. the package was
  already installed)
``changed``
  the task ran successfully and caused a change (e.g. installed or updated a
  package)
``failed``
  the task did not run successfully (e.g. the package was not found)

If a task fails, it is possible to define "rescue" operations to execute. For
example if patching a configuration file fails, the owning package could be
re-installed with the default configuration, and then patching can be attempted
again.

Modules
~~~~~~~

Ansible ships with a number of modules, each corresponding to a specific task.
For example, the ``apt`` module manages apt-get and related tools, the ``copy``
module copies files to client machines, the ``file`` module changes file
ownership, etc.

Variables
~~~~~~~~~

Variables can be defined for each host, and then substituted into tasks. This
makes managing things tied to physical hardware easier, for example the UUID of
the root partition would be a unique host variable for each machine.

Direct Commands
---------------

Modules can be run directly, as shown below::

  ansible --module-name shell --args "echo FOO" hostname

or shorter::

  ansible -m shell -a "echo FOO" hostname

The same options as for the playbook above are valid. Additionally, the
following exist:

``--module-name module`` or ``-m module``
  The module to execute

``--args`` or ``-a``
  The arguments to the module. They are a space-separated list of ``"key=value"``
  arguments. A more complete example for the shell module would be
  ``-a "chdir='folder name' echo FOO"``

``--become`` or ``-b``
  Run as an administrator, by default using ``sudo``
