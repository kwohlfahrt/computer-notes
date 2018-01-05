.. _programming-guide:

Programming
===========

This guide is a quick introduction to programming concepts. It uses the
command-line extensively which is available on Linux, macOS and Windows (through
the Windows Subsystem for Linux). If you are not fammilar with it, read the
:ref:`Command-line Guide <command-line-guide>` first to get started.

Concepts
++++++++

This section is a whirlwind tour to some programming concepts, but you are free
to skip it and make a start with the languages shown in the `Contents
<contents_>`_ below.

Imperative & Declarative
------------------------

The most straightforward way to think about a computer program is as a list of
instructions for the computer to run. Broadly, this know known as `imperative
programming`. These instructions are then translated into a form that can be
executed by the hardware inside the computer.

Declarative programming by contrast is about finding a way to express the
desired result, e.g. in a mathematical formula. A tool such as a compiler is
then left to figure out the details of how to achieve this. `functional
programming` and `database query languages` are two examples of declarative
programming.

Variables
---------

The ability to assign values to variables is a common feature of programming
languages. Whether the value of a variable can be modified after it has been
assigned varies, in imperative languages they usually can be modified, in
declarative ones this is often not possible.

Functions
---------

Another common feature is the ability to define functions, or sections of code
that can be re-used. Like mathematical functions they take some values as
inputs, and produce some new values as outputs. They may also have side-effects,
such as showing output on the screen, or creating a file. In declarative
languages, possible side-effects possible are often restricted.

Typing
------

Many programming languages allow (or require) the programmer to provide
additional information about the types of variables. This can be useful in
preventing errors or helping the user reason about the program. For example, if
the variable ``result`` is declared as a `Boolean` variable (`True` or `False`),
it may not hold any other values. The programmer then cannot assign ``"this
text"`` to this variable, or to multiply it by a number.

Although this is restrictive, it is a useful feature for catching errors early,
and the type of a functions inputs and outputs can be useful documentation of
what it does.

Types may either be static, which means they are explicitly declared for a
variable and cannot be changed, or dynamic where the type of a variable depends
on what is assigned to it. Modern statically-typed languages often have
type-inference, where the type of a variable is deduced from the value assigned
to it (but it still cannot be changed).

Compiling & Interpreting
------------------------

There are two approaches to translating computer programs into a form that can
be run by the hardware. The first is compiling, where a tool (the `compiler`)
reads the entire program and generates a binary file that can be run. The second
is interpreting, where an `interpreter` reads the program line-by-line, and
executes the appropriate action.

In general, compiled languages are faster, as it leaves more scope for the
compiler to optimize the program. There are many hybrid implementations, for
example the `PyPy` `Python` implementation functions as an interpreter, but
compiles frequently used sections of the program while it is running to speed it
up. `Haskell` is usually a compiled language, but interpreters for it exist as
well which can be useful for prototyping and teaching.

Contents
++++++++

.. toctree::
   :maxdepth: 2
   :glob:

   *
   */index

.. _idris: https://idris-lang.org
.. _PyPy: https://pypy.org
.. _CPython: https://python.org
.. _haskell: https://haskell.org
