Nix
===

The Nix package manager is a powerful tool for creating reproducible
environments to build software. NixOS is a Linux distribution based on this
package manager, but it can also be used on OSX, other Linux variants and the
experimental Genode operating system.

Language
--------

This section is a quick introduction to the nix language syntax.

Functions
~~~~~~~~~

Functions take a set of inputs and return an output::

  { input_a, input_b } : output

Packages
--------

Packages are described in the nix expression language. Each package is given by
a function, which takes the package dependencies and returns a derivation. For
example::

  { stdenv } :

Tools
-----

The main tool used is known as ``nix``. This has several subcommands, which are
described below.

Build
~~~~~

Builds the derivation given in a file.

Run
~~~

Opens a shell with a specified environment.

