Operators
=========

Some symbols and keywords in Python are known as operators. Their exact
behaviour depends on the type the are invoked on. For example, the ``+``
operator adds numbers, but concatenates lists::

  >>> 5 + 6
  11
  >>> [5] + [6, 7]
  [5, 6, 7]

This section describes some common operators, but bear in mind that they may
work differently on custom classes.

Most operators can also work in-place, by appending an ``=``::

  >>> x = 5
  >>> x += 3
  >>> x
  8

Operator Categories
+++++++++++++++++++

This section gives a quick description of some built-in operators.

Math
----

The operators ``+``, ``-``, ``*`` and ``/`` refer to addition, subtraction,
multiplication and division. ``//`` refers to floor division (i.e. dividing
rounding down), and ``%`` to the modulo or remainder operator. ``@`` is matrix
multiplication and ``**`` is exponentiation.

``-`` can also be used with a single operand (e.g. ``-1``) to calculate the
negative of a value. Similarly, the built-in ``abs`` function calculates the
absolute value.

Relational
----------

Comparisions can be made with ``==``, ``!=``, ``<``, ``>``, ``<=`` or ``>=`` for
equal, not equal, less, greater, less-or-equal and greater-or-equal
relationships.

Some values, notably booleans can be combined with ``and`` and ``or``. A boolean
can be inverted with the ``not`` keyword [#not]_. 

The ``in`` operator tests whether one value contains another.

Bitwise
-------

Similarly, the ``&``, ``|`` ``^`` operators are a bitwise or element-wise `and`,
`or` and `xor` [#xor]_. ``~`` is bitwise or element-wise inversion. ``<<`` and
``>>`` define left and right shifts respectively.

Indexing
--------

An element can be retrieved from a collection, like a list, using square
brackets::

  >>> l = [1, 5, 9, 10, 11, 14]
  >>> l[0], l[2], l[-1]
  (1, 9, 10)

By convention, negative values index from the end of the list.

A ``slice`` object can be used to get multiple objects. It takes a start, end,
and step value, separated by ``:``. All are optional::

  >>> l[0:3:2]
  [1, 9]
  >>> l[::2]
  [1, 9, 11]
  >>> l[0:3]
  [1, 5, 9]

Alternatively, slice objects can be manually constructed, using ``None`` to
represent omitted values::

  >>> l[slice(3)]
  [1, 5, 9]
  >>> l[slice(0, None, 2)
  [1, 9, 11]

Commas in between brackets simply result in a tuple being constructed.


Operator Module
+++++++++++++++

The ``operator`` module defines all the standard operators as functions, for
example ``operator.add(a, b)`` is the same as ``a + b``.

Defining
++++++++

A class can use an operator if the corresponding special method (starting and
ending with ``__``) is defined. For example::

  class Addable:
      def __init__(self, value):
          self.value = value

      def __add__(self, other):
          try:
              other = other.value
          except AttributeError:
              other = other
          return Addable(self.value + other)

      def __repr__(self):
          return "Addable(value={})".format(self.value)

This could now be used like this::

  >>> Addable(4) + 5
  Addable(value=9)

.. Note:: ``__repr__`` is only used for displaying the result, and is not
   strictly necessary to enable addition.

The complete list of overridable methods can be found in the the ``operator``
module.

Right-side Operators
--------------------

Most methods also have a corresponding `right-operator`. This can be useful for
compatibility with other classes. For example, the operation ``a + b`` looks for
``a.__add__``. If this is not found, or it returns the special value
``NotImplemented``, it looks for ``b.__radd__``.

We can improve our ``Addable`` class with this method::

  class Addable:
      ...

      def __radd__(self, other):
          return self + other

Now, the following will work::

  >>> 5 + Addable(4)
  Addable(value=9)

It is a good idea to return ``NotImplemented`` if you expect another class may
implement a fallback - Python will automatically convert this to a ``TypeError``
if no fallback is found.

.. [#not] The ``not`` operator is the only one that cannot be overridden with a
   special method (see `Defining`_).
.. [#xor] ``^`` is like ``|``, except ``(True ^ True) == False``
