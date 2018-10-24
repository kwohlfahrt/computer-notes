.. _nix-language:

Nix
===

Nix is a functional programming language designed for build environments. As
such, it is not designed for general purpose computation (though it can do it).
It is designed for use with the :ref:`nix-guide` package manager.

To start the interpreter, run the ``nix repl`` comand. In the REPL, values can
be assigned to variables with a ``=``::

  > x = 3
  > x
  3

Types
-----

A few types of values exist. The type of a value can be inspected with the
``typeOf`` builtin function::

  > builtins.typeOf 3
  "int"

Numbers
~~~~~~~

Both integer and floating-point numbers are supported.

Strings
~~~~~~~

Strings are also fully supported. Single-line strings are enclosed in double
quotes, and multi-line strings are enclosed in double-single quotes::

  > "foo"
  "foo"
  > ''foo
    bar''
  "foo\nbar"

Note that multi-line strings strip a single leading newline, and any common
leading whitespace::

  > ''
      foo
        bar
      baz
    ''
  "foo\n  bar\nbaz\n"

`String interpolation` can be used to embed other values in a string, surrounded
by ``${}``. This can be arbitrarily nested::

  > x = 3
  > "foo ${builtins.toString (1 + x)}"
  "foo 4"

Sets
~~~~

Attribute sets are unordered key-value mappings, from a string to a value. Keys
and values are separated by a ``=``, and key-value pairs end with a ``;``::

  > { foo = 1; bar = "baz"; }
  { bar = "baz"; foo = 1; }

Keys may contains spaces or other unusual characters, but must then be enclosed
in quotes. Quoted keys may also use string interpolation::

  > { "foo bar" = 1; "baz${toString 1}" = 3; }
  { baz1 = 3; "foo bar" = 1; }

A value in a set is accessed with a ``.``::

  > { "foo" = 1; }.foo
  1

Attempting to access a missing value is an error, but a default value may be
provided with ``or``::

  > s = { "foo" = 1; }
  > s.bar
  error: attribute 'bar' missing, at (string):1:1
  > s.bar or 2
  2

Functions
~~~~~~~~~

Functions take a single input and return an output. For example, this function
adds ``3`` to its parameter::

  > input: 3 + input
  «lambda @ (string):1:1»

Functions are applied by writing the parameter after the function::

  > (input: 3) 4
  7

Functions can be nested to create a function of multiple parameters (the
parentheses here are not necessary)::

  > add = (a: (b: a + b))
  > (add 3) 4
  7

A function can also pattern-match on its arguments, so if the input is a set
this can be deconstructed::

  > f = {a, b}: a + b
  > f { a = 1; b = 2; }
  3

An ``...`` can be used to indicate that other parameters are accepted (but
ignored), passing extra parameters would otherwise be an error::

  > ({a, b}: a + b) { a = 1; b = 2; c = 3; }
  error: anonymous function at (string):1:2 called with unexpected argument 'c', at (string):1:1
  > ({a, b, ...}: a + b) { a = 1; b = 2; c = 3; }
  3

An ``@name`` after the parameters can be used to capture the entire input set::

  > ({...}@input: builtins.length (builtins.attrNames input)) { a = 2; b = 3; }
  2
