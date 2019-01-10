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

Patterns
--------

The `nixpkgs` set uses several patterns to arrive at its final design.

Inputs
~~~~~~

The first of these is the `input` design pattern, where a package is defined as
a function that takes all of its dependencies as inputs. This makes it easy to
replace a dependency, by simply calling the function with a different argument.

A sample package might look like::

  { stdenv, libjpeg, jpegSupport ? true }:

  stdenv.mkDerivation {
    name = "hello-world";
    src = ./hello-world.tar.gz;
    buildInputs = if jpegSupport then [ libjpeg ] else [];
  }

The ``stdenv`` argument contains useful, standard build tools (``gcc``,
``make``, etc) and some scripts which try to unpack and build projects with
common default options.

The other arguments are inputs needed at build-time or run-time, and it is all
tied together with the ``mkDerivation`` function.

Call-Package
~~~~~~~~~~~~

The use of the `input` design pattern is made easier with the `call-package`
pattern. The ``callPackageWith`` function takes a base package set, a function
for a package and a set containing any additional arguments. The base package
set is used to give values to any function arguments not defined in the
additional arguments parameter, matching them by name. For example::

  > pkgs = { foo = 1; bar = 2; baz = 3; }
  > fn = { foo, bar }: foo + bar
  > lib.callPackageWith pkgs fn {}
  3
  > lib.callPackageWith pkgs fn { bar = 5; }
  6

As a convenience, the function argument may also be a path, which is imported
and treated as a function.

If the Inputs_ example was in a file named ``hello-world.nix``, we could do::

  > nixpkgs = import <nixpkgs> {}
  > hello = lib.callPackageWith nixpkgs.pkgs ./hello-world.nix {}

But, if we wanted to build without JPEG support, we could just call it with
different arguments::

  > lib.callPackageWith nixpkgs.pkgs ./hello-world.nix { jpegSupport = false; }

Overrides
~~~~~~~~~

Finally, the `override` design pattern allows us to replace function arguments
on an existing derivation, essentially re-calling the function with different
arguments. Imagine we had called the example derivation like this::

  > hello-world = lib.callPackageWith nixpkgs.pkgs ./hello-world.nix {}

And now we wanted a copy that was otherwise identical, just without JPEG
support. ``lib.callPackageWith`` adds an ``override`` attribute that allows us
to do just that::

  > hello-world.override { jpegSupport = false; }

The implementation can be found ``<nixpkgs/lib/customization>``, and is fairly
simple.

Tools
-----

The main tool used is known as ``nix`` [nix-cmd]_. This has several subcommands,
which are described below.

Build
~~~~~

``nix build`` builds the derivation given in a file.

Run
~~~

``nix run`` opens a shell with a specified environment.

.. [nix-cmd] The ``nix`` command mostly replaces older commands prefixed with
   ``nix-`` (e.g. ``nix build`` replaces ``nix-build``). However, some features
   are not yet available in the new interface (e.g. ``nix-shell``).
