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

Fix-Point
~~~~~~~~~

The `fix-point` system is a way of dynamically referencing variables in a set.
Normally, variables are resolved at declaration time. For example::

  > rec { x = "abc"; y = x + "123"; } // { x = "xyz"; }
  { x = "xyz"; y = "abc123"; }

Even though ``x`` has been updated, ``y`` is unmodified. If we want ``y`` to
always be in sync with ``x``, we can define a self-referential function as
follows::

  > fix = fn: let fixpoint = fn fixpoint; in fixpoint
  > fix (self: { x = "abc"; y = self.x + "123"; })
  { x = "abc"; y = "abc123"; }

As we can see, ``fix`` on its own approximates the ``rec`` keyword. This works
because the field ``x`` does not reference itself or ``y``, so the computation
eventually terminates without any further calls of the function.

A ``fixWithOverride`` function allows us to replace values before the fix-point
is evaluated::

  > fixWithOverride = fn: overrides: fix (self: (fn self) // overrides)
  > fixWithOverride (self: { x = "xyz"; y = self.x + "123"; }) { x = "xyz"; }
  { x = "xyz"; y = "xyz123"; }

The value of ``y`` now represents the value of ``x`` when after the override was
applied.

Overlays
~~~~~~~~

The nixpkgs set supports overlays using the fix-point system. Overlays can be
defined in ``~/.config/nixpkgs/overlays``, or by adding ``nixpkgs-overlays`` to
``NIX_PATH``.

An overlay is a function of the form ``self: super: { ... }``. The second
argument, ``super``, is the result of the composition before the current
overlay. The first argument is the fix-point of the result after all overlays
have been applied.

``self`` should only be used for attributes that are used to satisfy
dependencies, so that they take into account overrides in future overlays.
``super`` should be used for other attributes, such as functions and attributes
which are overridden to avoid infinite recursion.

The design of overlays allows many of them to be chained, each one adding or
modifying the packages in the set.

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
