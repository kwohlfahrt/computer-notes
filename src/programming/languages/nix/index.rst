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

The language is generally not whitespace-sensitive, except around the ``-``
operator. ``a-b`` is the name of a single variable, while ``a - b`` is the value
of ``b`` subtracted from ``a``.

Language
########

Types
-----

A few types of values exist. The type of a value can be inspected with the
``typeOf`` builtin function::

  > builtins.typeOf 3
  "int"

All values can be compared for (in)equality with ``==`` and ``!=``.

Boolean
~~~~~~~

The boolean values are ``true`` and ``false``.

Operations
++++++++++

Boolean 'and', 'or' and 'not' are ``&&``, ``||`` and ``!`` respectively.

Additionally, the ``->`` is used for logical implitation (i.e. ``a -> b`` is
equivalent to ``if a then b else true`` or ``!a || b``). This is most often used
to test a requirement is satisfied, e.g. ``usePlugin -> pluginVersion > 2``.

Numbers
~~~~~~~

Both integer and floating-point numbers are supported.

Operations
++++++++++

Numbers can be added, subtracted, multiplied and divided with the usual
operators: ``+``, ``-``, ``*`` and ``/`` respectively. The usual arithmetic
comparisons (``>``, ``<``, ``>=`` and ``<=``) are supported.

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

Operations
++++++++++

Strings may be concatenated with ``+``::

  > "foo" + "bar"
  "foobar"

Paths
~~~~~

Unquoted strings containing at least one slash (``/``) are interpreted as paths.
Paths beginning with ``/`` are interpreted as absolute paths, paths beginning
with ``~`` are interpreted relative to the users home directory, and all other
paths are interpreted relative to the nix file being parsed.

Search Path
+++++++++++

The interpretation of paths enclosed in angle brackets (e.g. ``<foo/bar>``)
depends on the ``NIX_PATH`` environment variable. ``NIX_PATH`` is a
colon-separated list of directories to search. For example, ``<foo/bar>`` with a
``NIX_PATH`` of ``/etc/nix-exprs`` will search for ``/etc/nix-exprs/foo/bar``.

A directory may be given a prefix that will replace the first element of the
path if it matches. For example, ``<foo/bar>`` with a ``NIX_PATH`` of
``foo=/etc/nix-exprs`` will search ``/etc/nix-exprs/bar``. Prefixed paths will
*not* be searched if the prefix does not match.

Finally, a directory may be a URL beginning with ``http://`` or ``https://``, in
which case this URL should point to a tarball with a single top-level folder
that will be unpacked to a temporary location before being searched.

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

The ``inherit`` keyword can be used to bind an attribute to a variable with the
same name::

  > x = 3
  > y = 4
  > { inherit x y; z = 5; }
  { x = 3; y = 4; z = 5; }

Operations
++++++++++

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

Two sets can be merged with ``//``, with values in the second set replacing
values in the first::

  > { a = 1; b = 2; } // { b = 3; c = 4; }
  { a = 1; b = 3; c = 4; }

Functions
~~~~~~~~~

Functions take a single input and return an output. For example, this function
adds ``3`` to its parameter::

  > input: 3 + input
  «lambda @ (string):1:1»

Functions are applied by writing the parameter after the function::

  > (input: 3 + input) 4
  7

Functions can be nested to create a function of multiple parameters (the
parentheses here are not necessary)::

  > add = (a: (b: a + b))
  > (add 3) 4
  7

A function can also pattern-match on its arguments, so if the input is a set
this can be deconstructed::

  > ({a, b}: a + b) { a = 1; b = 2; }
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

Conditionals
------------

Conditionals are expressed as ``if``-``then``-``else`` structures::

  > if 1 < 2 then "foo" else "bar"
  "foo"

Bindings
--------

There are a few different ways to change which variables are in scope. Both
apply to the following expression.

Let
~~~

Let-bindings add new variables into a scope::

  > let x = 3; y = 4; in x + y
  7

With
~~~~

With bindings bring all members of an attribute set into scope::

  > with { x = 3; y = 4; }; x + y
  7

Laziness
--------

Expressions are lazily evaluated (i.e. only when their values are needed)::

  > a = 4 / 0
  > a
  error: division by zero, at (string):1:2

Note that the error only occured when we attempted to evaluate ``a``, not when
we assigned the expression.

Standard Library
################

.. toctree::
   :maxdepth: 1
   :glob:

   *
