.. _c-guide:

C
=

C is considered a low-level programming language, in that it is similar to the
machine code executed by computers directly [#low-level]_. It does not offer as
many useful features as other languages, but it can be very fast and is
available on almost all platforms. Many higher level programming languages are
capable of interfacing with C code in some way, so it serves as a common
language for communicating between them.

Compiling
+++++++++

C does not offer a REPL (read-eval-print loop) like many other languages (e.g.
Python). This means that a whole program must be compiled and then run from the
:ref:`command-line <command-line-guide>`. For example, suppose we have the
following C program::

  #include <stdio.h>

  int main(int argc, char ** argv) {
    for (unsigned int i = 0; i < argc; i++){
      printf("%s ", argv[i]);
    }
    printf("\n");
    return 0;
  }

Most Linux distributions have ``cc`` available as a C compiler. OSX uses the
``clang`` comand instead. The following command compiles the file ``echo.c``
(containing the program above), and saves the result in a file called
``echo``::

  > cc -o echo echo.c

Now, we can run the resulting program::

  > ./echo Hello, world!
  Hello, world!

Program Structure
+++++++++++++++++

Constructs which will show up frequently below are expressions, statements, and
blocks.

Expressions
-----------

Expressions are fragments of code that evaluate to a value. They may be
`variables <Variables_>`_ (``x``), `function <Functions_>`_ evaluations
(``add(x, y)``), `operator <Operators_>`_ evaluations (``x + 2``) or `literals
<Literals_>`_ (``4``). Assignment of a value to a variable is also an
expression, and returns the value being assigned (``x = 2`` evaluates to ``2``).

The comma (``,``) can be used to evaluate multiple expressions where only one is
expected. All expressions will be evaluated, but only the last one will be
returned. For example, ``x = (puts("foo"), 2, 3)`` will assign ``3`` to ``x``.
The fact that all expressions are evaluated is important because any
side-effects will be observed, in this case ``foo`` will be printed.

Statements
----------

Statements in contrast, do not return values. Every statement is terminated by a
semi-colon ``;``.

Blocks
------

Blocks are groups of statements, surrounded by curly braces ``{}``.

Types
+++++

Literals
++++++++

A literal is a value defined in the source code of the program.

Numbers
-------

Several kind of numbers are supported.

Integers
~~~~~~~~

Integers (whole numbers) can be written in decimal form (``23``). The integer
will be sized such that the number can be represented. The suffix ``u`` can be
added to specify that the number is `unsigned`. ``l`` or ``ll`` can be added to
specify the number should be at least the size of a ``long`` or ``long long``
integer respectively.

Floats
~~~~~~

Floats, or floating precision numbers are decimals with a specific number of
significant figures (``1.4``). Values are double-precision floats, unless the
specifier ``f`` is appended to specify single-precision.

Characters
~~~~~~~~~~

Characters are single letters enclosed in single quotation marks (``'a'``).

.. note:: some complex characters, e.g. ``ü``, are actually composed of a
   character and a modifier drawn in one space, so do not count as C characters.

Strings
~~~~~~~

Variables
+++++++++

A variable is declared by stating its type, followed by its name::

  int i;

This may optionally be followed by an assignment::

  int k = 3;
  int j = k;

If a value is not specified, expressions reading from the value may evaluate to
any value.

Memory
------

C programs assume that the computer has a linear, continuous range of memory
available. This is split into three sections - constant, stack and heap memory.

Printing
--------

Due to the lack of a REPL, it is very useful to be able to print the contents of
a variable in C. This is done with the ``printf`` `function <Functions_>`_. The
first argument to this function is the `format string`, specially formatted text
that will define how the variables are printed. Every instance of ``%``,
followed by a letter, will be replaced by the value of a variable from the
remaining arguments. The letter used depends on the type of the variable.

=================== ==========================================================
Format code         Variable type
=================== ==========================================================
``d``, ``i``        Signed integer, formatted as decimal
``u``, ``o``, ``x`` Unsigned signed integer, formatted as decimal, octal or
                    hexadecimal
``c``               single character
``s``               null-terminated string
``p``               pointer
``f``               floating-point value in normal notation
``e``               floating-point value in scientific notation
``g``               floating-point value in normal or scientific notation, as
                    appropriate for its magnitude
=================== ==========================================================

For example, the variables below::

  char s[] = "foobar";
  unsigned int i = 3;
  int j = 4;
  float k = 5.0;

Could be used as follows in a ``printf`` call::

  printf("printed: %s %d %u %f '%c' %p\n", s, i, j, k, s[2], &j);

This would output::

  printed: foobar 3 4 5.0 'o' 0x7ffe4517656c

Note that arbitrary characters can be mixed in with the format codes. Also, to
print a newline, the ``\n`` `escape` is used. Other characters that may be
escaped are tabs (``\t``), quotes (``\"``) and backslashes (``\\``). To print a
percent sign, double it (``%%``).

Additionally, integer format codes may be preceeded by a length specifier, that
specifies the size of the argument (if omitted, it is assumed to be the size of
an ``int``).

=========== =============
Length code Size
=========== =============
``hh``      ``char``
``h``       ``short``
``l``       ``long``
``ll``      ``long long``
``z``       ``size_t``
``t``       ``ptrdiff_t``
=========== =============

Floating point values allow the ``L`` length code for ``long double`` values.

Functions
+++++++++

From a programmer's perspective, executing a C program starts with the ``main``
function. This is known as the `entry point` to the program.

Defining
--------

Calling
-------

Operators
+++++++++

Comments
++++++++



.. [#low-level] C does hide many details of computer hardware, such as the
   multiple levels of caching of memory. It is still lower level than most other
   languages.

.. [#nostd] Technically, it is the ``_start`` function. However, most C programs
   use the standard library, which implements that function for you.
