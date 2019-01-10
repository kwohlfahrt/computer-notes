Built-in Functions
==================

These are functions that are built-in to the language (i.e. defined in the C++
interpreter source).

Derivation
----------

The ``derivation`` built-in function is the main way that the nix language
interfaces with the build system. It takes a set as an argument, with the
following parameters:

Arguments
~~~~~~~~~

``system``
  The platform the derivation is built on, for example ``"x86_64-linux"``. The
  build may only be performed on a machine of this type.
``name``
  A symbolic name for the package.
``builder``
  The program used to build the package. It may be a derivation or a file
  reference. If this exits with status ``0``, the build succeeded.

Additionally, the following optional arguments can be passed:

``args``
  The command-line arguments to ``builder``
``outputs``
  The names of the outputs the derivation produces (e.g. ``[ "lib" "bin" ]``).
  By default a single output named ``out`` is produced. The outputs can be
  accessed as attributes on the derivation, and the derivation itself is the
  same as its first output.

All other attributes are given as environment variables to the derivation. The
exact result depends on the type of the argument:

- Numbers and strings are passed as-is
- Paths are copied to the nix store and the resulting location is passed as a
  string
- Derivations are built, and the location of the output in the store is passed
  as a string
- Lists of the above types are concatenated, separated by spaces.
- ``false`` and ``null`` are passed as the empty string, ``true`` is passed as
  the string ``1``

Environment
~~~~~~~~~~~

An environment variable is set for each available output with a value of the
store path of that output. Common environment variables are set to placeholder
values (``HOME``, ``PATH``, ``TMP``, ``TMPDIR``, etc).

Example
~~~~~~~

This minimal example is a derivation that creates a single output file. First,
load the standard ``nixpkgs`` set on the REPL [#nixpkgs]_::

  > :l <nixpkgs>
  Added 9824 variables.

This is necessary to access ``bash``, our builder. Then, we create a simple
derivation that uses bash to put some content into our output::

  > d = derivation {
      name = "hello-world";
      builder = "${bash}/bin/bash";
      args = [ "-c" "echo Hello, world! > $out" ];
      system = builtins.currentSystem;
    }
  > d
  «derivation /nix/store/ri8cbykg85w73phxfxhq9cw7zwk4qrkn-hello-world.drv»

Finally, we build the derivation::

  > :b d
  [1 built, 0.0 MiB DL]

  this derivation produced the following outputs:
    out -> /nix/store/x04441gm8zyrgn9sw4c3s1yagpn3l8b1-hello-world

We can then see that the contents of our file is what we expect::

  $ cat /nix/store/x04441gm8zyrgn9sw4c3s1yagpn3l8b1-hello-world
  Hello, world!

The store path ends with the ``name`` attribute of the derivation, and begins
with a hash of all of its inputs. If we build the same derivation again, it will
simply return this path without rebuilding it::

  > :b d

  this derivation produced the following outputs:
    out -> /nix/store/x04441gm8zyrgn9sw4c3s1yagpn3l8b1-hello-world

.. [#nixpkgs] This example assumes ``<nixpkgs>`` is on your ``NIX_PATH``. You
   can pass a normal path to a copy of the repository instead.
