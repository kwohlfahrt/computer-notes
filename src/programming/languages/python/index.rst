.. _python-guide:

Python
======

Python is an easy-to-use programming language, with many ready-to-use packages
for common tasks. It commes with an interactive interpreter, which can be
started with the ``python`` command [#py3]_. This will present you with an
interactive prompt::

  >>>

Here, you can enter `statements` to be evaluated by the interpreter. An
`expression` is a statement that results in another value when evaluated, which
will be printed below::

  >>> 2 + 2
  4

A statement may also modify the state of the interpreter when executed, such as
defining a variable::

  >>> x = 4

Note this does not print anything, but now the variable ``x`` has a value, and
can be printed::

  >>> x
  4

Expressions may include parentheses to avoid ambiguity::

  >>> 4 + 5 * 10
  54
  >>> (4 + 5) * 10
  90

Or to continue over several lines::

  >>> (4 + 5 +
  ...  6 + 7)
  22

Literals
++++++++

The simplest kind of expression is a `literal` values::

  >>> 5
  5
  >>> 'Hello, world!'
  'Hello, world!'
  >>> True
  True
  >>> None
  >>>

The different kinds of literal are described in more detail below, and include
numbers, `strings <Strings_>`_ (text) and `booleans` (`True` or `False`) and the
special value ``None``. They also include the more complex `lists <Lists_>`_,
`tuples <Tuples_>`_, `dictionaries <Dictionaries_>`_, and `sets <Sets_>`_.

Numbers
-------

There are three kinds of numbers in Python: `integers`, `floats` and `complex
numbers`.

Integers
~~~~~~~~

Integers are positive or negative whole numbers. Most operations on integers
return other integers, with the notable exception of division which returns a
`float`.

  >>> 3 + 5
  8
  >>> 4 / 2
  2.0

The special `floor division` operator returns an integer, rounded down::

  >>> 5 // 2
  2

Floats
~~~~~~

Floats are an approximation of real numbers (in the mathematical sense). They
are constructed with a decimal number, followed by an optional exponent
separated by an ``e``::

  >>> 0.2
  0.2
  >>> 1.46e3
  1460.0

They can hold very large values and very small values, but have limited
precision which can lead to rounding errors::

  >>> 0.3 + 0.3 + 0.3
  0.8999999999999999

Complex Numbers
~~~~~~~~~~~~~~~

Complex numbers consist of a real and an imaginary part, each of which is a
float::

  >>> 1+0.5j
  (1+0.5j)

Strings
-------

Strings may be delimited by single ``'`` and double ``"`` quotes, these are
interchangable::

  >>> "Hello, world!"
  'Hello, world!'

Trying to define a string which contains the same kind of quotation mark used to
begin it is an error::

  >>> "Hello, "user"!"
    File "<stdin>", line 1
      "Hello, "user"!"
                  ^
  SyntaxError: invalid syntax

This is where the multiple kinds are useful::

  >>> 'Hello, "user"!'
  'Hello, "user"!'

Multi-line strings are delimited by three quotation marks (``'''`` or ``"""``)::

  >>> """Hello you!
  ... and you!"""
  'Hello you!\nand you!'

The ``\n`` in the output represents a newline, this is known as :ref:`escaping`.

Lists
-----

Lists are constructed by placing comma-separated values between square
brackets::

  >>> [1, 2, 5]
  [1, 2, 5]

They may be `nested` (i.e. lists may contain other lists)::

  >>> [[1], [2, 3], [5, 0]]
  [[1], [2, 3], [5, 0]]

Lists usually contain elements of the same type, but may contain different
types::

  >>> ["text", 3, False, [3, 4]]
  ["text", 3, False, [3, 4]]

Tuples
------

Tuples are very similar to lists, except they usually contain values of
different types. They are simply values separated by commas::

  >>> "text", 1, True
  ("text", 1, True)

They may be nested, but parentheses are necessary to avoid ambiguity::

  >>> ("text", 1), 5
  (("text", 1), 5)

Dictionaries
------------

Dictionaries are mappings of one value (the `key`) to another (the `value`).
Keys and values are separated by ``:``, and entries are separated by ``,``. The
whole thing is contained in curly brackets (``{`` and ``}``). For example, one
might create a dictionary to store the populations of cities::

  >>> {"Berlin": 3671000, "London": 8787892, "New York": 8175133}
  {'Berlin': 3671000, 'London': 8787892, 'New York': 8175133}

Here, the keys are the names of cities and the values are the population
numbers. There can only be one value for a particular key, any repeats will
replace the original value::

  >>> {"New York": 400, "New York": 8175133}
  {'New York': 8175133}

The order of keys and values in a dictionary is undefined. There are some
restrictions on the values suitable for keys, they must be `hashable`_ and
should not be `mutable`_. `Tuples`_ can be used as keys, whereas `lists
<Lists_>`_ cannot. There are no restrictions on the values.

Sets
----

Sets are like dictionaries, but they do not contain values. This is useful when
you only want to keep track of what values are contained in a set, but not how
many times, or in what order::

  >>> {1, 1, 4, 6, 3, 1, 4}
  {1, 3, 4, 6}

Variables
+++++++++

We observed assigning to a variable above. Trying to use a variable which has
not been assigned to is an error::

  >>> y
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  NameError: name 'y' is not defined

A new value can be assigned to a variable, replacing the old one::

  >>> x = 3
  >>> x
  3

Variables can be used in expressions::

  >>> x + 6
  9

The right-hand side of an assignment can be any valid expression::

  >>> y = 5
  >>> x = x + 4 - y
  >>> x
  2

It is possible to assign values to multiple variables from a tuple (or other
sequence), this is known as `unpacking`::

  >>> a, b, c = 1, 2, 3
  >>> b
  2

More complex structures are also possible, for example unpacking can be nested::

  >>> a, (b1, b2), c = 1, (2, 'b'), ('c', 3)
  >>> b1, c
  (2, ('c', 3))

In this case, the middle element of the tuple (which in turn is also a tuple) is
split into two variables, while the first and last elements are assigned to a
single variable.

A ``*`` can be used once to refer to the remaining values which will be
collected in a list::

  >>> a, *rest, c = 1, 2, 3, 4
  >>> a, rest, c
  (1, [2, 3], 4)

Certain names, known as `keywords` are reserved and cannot be used as variable
names::

  >>> is = 3
    File "<stdin>", line 1
      is = 3
       ^
  SyntaxError: invalid syntax

A variable may be deleted with the ``del`` keyword, but this is rarely
necessary::

  >>> del x
  >>> x
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  NameError: name 'x' is not defined

Control Flow
++++++++++++

A key part of programming is the ability to modify the `control flow`. This
means executing statements zero or more times depending on certain conditions.

If
--

An `if-statement` executes one or more statements if an expression is true. The
statements controlled by the condition (the body) must be indented, and end with
a single empty line::

  >>> x = 5
  >>> if x < 20:
  ...     y = 4
  ...     x = y + x
  ...
  >>> x
  9

An if-statement may be followed by zero or more `elif` (else if) statements, and
finally an optional `else` statement::

  >>> if x > 10:
  ...     kind = "large"
  ... elif x > 3:
  ...     kind = "medium"
  ... else:
  ...     kind = "small"
  ...
  >>> kind
  'medium'

Loops
-----

Loops allow you to repeat a number of statements. This is very useful for
automating tedious tasks.

While
~~~~~

A `while-loop` continues running while an expression is true::

  >>> x = 2
  >>> while x < 10:
  ...     x = x + 5
  ...
  >>> x
  12

Be careful to not write an infinte loop where the condition is never true::

  >>> while x > 0:
  ...     x = x + 5
  ...

If you accidentally do this, it can be interrupted by pressing ``Ctrl`` + ``c``::

  ^CTraceback (most recent call last):
    File "<stdin>", line 2, in <module>
  KeyboardInterrupt
  >>>

For
~~~

A `for-loop` runs once for each element in a sequence, like a list::

  >>> items = [8, 4, 5, 7]
  >>> total = 0
  >>> count = 0
  >>> for i in items:
  ...     if i > 5:
  ...         total = total + i
  ...     count = count + 1
  ...
  >>> count, total
  4, 15

Unpacking can be used in a loop::

  >>> total = 0
  >>> for a, b in [(1, 2), (5, 7)]:
  ...     total = total + a - b
  ...
  >>> total
  -3


Functions
+++++++++

A function is defined with the ``def`` keyword, followed by the name of the
function, and then its arguments (inputs) in parentheses::

  >>> def add(a, b):
  ...     return a + b
  ...
  >>>

End the function with a blank line with no indentation. The function can now be
used in an expression as shown::

  >>> add(3, 4)
  7

The arguments may be any Python expression. Functions can be assigned to
variables just like any other value::

  >>> also_add = add
  >>> also_add(5 - 1, 6)
  10

Variables defined inside a function are not accessible outside of it::

  >>> def add3(a, b, c):
  ...     tmp = a + b
  ...     return tmp + c
  ...
  >>> add3(1, 2, 3)
  6
  >>> tmp
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  NameError: name 'tmp' is not defined

Objects
+++++++

Every value in Python is an `object`. This means it has attributes, which can be
accessed by a ``.``. For example, complex numbers have `real` and `imaginary`
parts::

  >>> (1+3j).real
  1.0
  >>> (1+3j).imag
  3.0

To view all attributes of an object, use the ``dir`` function::

  >>> dir(1+3j)
  ['__abs__', ..., 'conjugate', 'imag', 'real']

There will be many attributes beginning and ending with ``__`` (omitted above
for brevity), these are special attributes used by built-in python functions.
For example, the ``__doc__`` attribute contains documentation shown by the
``help`` function.

Methods
-------

Some attributes are functions that operate on the object, called `methods`. For
example ``conjugate``::

  >>> (1+3j).conjugate
  <built-in method conjugate of complex object at 0x7fb722a79350>

These functions operate on the object itself (implicitly, you do not have to
provide it) and zero or more additional parameters::

  >>> (1+3j).conjugate()
  (1-3j)
  >>> cities = {"Berlin": 3671000, "London": 8787892, "New York": 8175133}
  >>> cities.get("Berlin")
  3671000

Operators, such as ``+`` or ``/``, are implemented with special methods in
Python (``__add__`` and ``__div__`` for those examples).

IDs
---

Every object has a unique `id`, this can be shown with the ``id`` function. The
exact value may be different when you start a new Python interpreter::

  >>> id("a string")
  140424537833776
  >>> id(add)
  140424549875224

Some objects are `cached` by Python, for example small integers. This means
Python creates the object once, and if you use the same number again it re-uses
the object to save resources::

  >>> id(4)
  10938944
  >>> x = 4
  >>> id(x)
  10938944
  >>> y = 4
  >>> id(y)
  10938944

`Mutable <mutability_>`_ objects cannot be cached, so lists are always distinct
objects even if they are identical::

  >>> x = []
  >>> id(x)
  140424537191752
  >>> y = []
  >>> id(y)
  140424537321928

However, ids may be re-used if the original object is deleted::

  >>> x = []
  >>> id(x)
  140424537325320
  >>> del x
  >>> x = []
  >>> id(x)
  140424537325320

These are not the same object. However, the new list happens to have the same ID
as the old list (which no longer exists).

Mutability
----------

Many objects are mutable, meaning that their values can be changed. For example,
lists can have additional values appended to them::

  >>> names = ["Alice", "Bob"]
  >>> names
  ['Alice', 'Bob']
  >>> names.append("Charlie")
  >>> names
  ['Alice', 'Bob', 'Charlie']

Some objects are immutable, meaning that their values cannot be changed. These
include strings, integers and tuples. This does not mean the value of a variable
can't be changed, but the variable will be a new object with that value::

  >>> x = 3
  >>> x
  3
  >>> id(x)
  10938912
  >>> x = x + 4
  >>> x
  7
  >>> id(x)
  10939040

The difference between mutable and immutable objects is most clear when they are
assigned to more than one variable::

  >>> x = 3
  >>> y = x
  >>> x = x + 4
  >>> x, y
  (7, 3)

  >>> more_names = names
  >>> more_names.append("Dave")
  >>> names, more_names
  (['Alice', 'Bob', 'Charlie', 'Dave'], ['Alice', 'Bob', 'Charlie', 'Dave'])

Changing ``x`` does not affect ``y``, as a new object is assigned to the name.
Changing ``more_names`` does affect ``names``, as the object which is assigned
to both variables is modified.

Comments
++++++++

Anything following the symbol ``#`` is a comment, and will be ignored::

  >>> 4  # This is the number 4
  >>> # This whole line is a comment
  ...
  >>>

Python Files
++++++++++++

What we have seen so far has all been done interactively. For larger projects,
you will want to save your work in a file, so you can edit it more easily.
Python files are plain text files (see :ref:`files`), containing code like you
would enter at the interpreter::

  def add(a, b):
      return a + b

  print(add(3, 5))

This does not print the output of each statement like the interactive
interpreter, so you will need to use the ``print`` function for visible output.
After saving the block above as ``adder.py``, it could then be run as follows
from the :ref:`command-line <command-line-guide>`::

  > python adder.py
  8
  >

See `Modules` in the `Advanced Topics` section for information on how to split
your code over multiple files.

Advanced Topics
+++++++++++++++

.. toctree::
   :maxdepth: 1
   :glob:

   *

.. [#py3] This guide uses `Python 3`, you may have to run ``python3`` if your
   system has the older `Python 2` installed as well. You can check the version
   with the ``--version`` option.

.. _hashable: https://docs.python.org/3/glossary.html#term-hashable
