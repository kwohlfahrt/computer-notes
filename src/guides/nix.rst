.. _nix-guide:

Nix
===

The Nix package manager is a powerful tool for creating reproducible
environments to build software. NixOS is a Linux distribution based on this
package manager, but it can also be used on OSX, other Linux variants and the
experimental Genode operating system.

See the document on the :ref:`nix-language` language for language feature, this
document discusses use of the Nix package manager and conventions in the
canonical `nixpkgs` package set.

Packages
--------

Packages are described in the nix expression language. Each package is given by
a function, which takes the package dependencies and returns a derivation. For
example::

  { stdenv } :

Tools
-----

The main tool used is known as ``nix`` [nix-cmd]_. This has several subcommands,
which are described below.

Build
~~~~~

``nix build`` Builds the derivation given in a file.

Run
~~~

``nix run`` opens a shell with a specified environment.

.. [nix-cmd] The ``nix`` command mostly replaces older commands prefixed with
   ``nix-`` (e.g. ``nix build`` replaces ``nix-build``). However, some features
   are not yet available in the new interface (e.g. ``nix-shell``).
