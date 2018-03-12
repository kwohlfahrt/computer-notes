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

Useful arguments include

``--check`` or ``-C``
  do not execute any tasks, just print what would be executed.
``--limit SUBSET`` or ``-l SUBSET``
  only run the playbook on a subset of hosts. Can be a group, slice of a group
  or comma-separated hostnames.
``--ask-pass`` or ``-k``
  Use challenge-response (i.e. password) authentication. This is useful if
  Kerberos is not working.

Additional configuration is found in the ``ansible.cfg`` file.

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

Vaults
------

Vaults are encrypted files that can be used to safely store secrets. Vaults are
managed with the ``ansible-vault`` tool.

They can be assigned to `identities`, which are labels that apply to one or more
vaults and share a password. By default, ``ansible-vault`` looks for a file
matching the identity containing the password, this can be overridden with the
syntax ``identity@filename`` - the special filename ``prompt`` prompts the user.

To create a new vault::

  ansible-vault create --new-vault-id identity@password_file filename.yml

They can be located in any of the locations ansible variables are read from. The
vault identity can be changed with the ``rekey`` command (it takes the same
``--new-vault-id`` parameter).

To use a vault, use the ``--vault-id`` parameter to ``ansible-playbook``. This
parameter can be specified multiple times::

  ansible-playbook --vault-id shared@prompt --vault-id personal@prompt site.yml
